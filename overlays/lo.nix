inputs: final: prev:
let
  tmux = "${final.tmux}/bin/tmux";
  awk = "${prev.gawk}/bin/awk";
  sed = "${prev.gnused}/bin/sed";
  wc = "${prev.coreutils}/bin/wc";

  # Copies stdin to the system clipboard. Under Hyprland the X11 tools are not
  # available, so prefer wl-copy whenever we are on a wayland session.
  clipboard =
    if prev.stdenv.hostPlatform.isDarwin then
      "/usr/bin/pbcopy"
    else
      ''
        if [ -n "''${WAYLAND_DISPLAY:-}" ]; then
          ${prev.wl-clipboard}/bin/wl-copy
        else
          ${prev.xclip}/bin/xclip -selection clipboard
        fi'';
in
{
  # `lo` — last output. Prints the last command of the current tmux pane and
  # everything it printed on stdout, so it can be piped into anything else.
  lo = prev.writeShellScriptBin "lo" ''
    set -uo pipefail

    copy=0

    while [ "$#" -gt 0 ]; do
      case "$1" in
        -c | --copy) copy=1 ;;
        -h | --help)
          echo "usage: lo [-c|--copy]"
          echo
          echo "Print the last command of the current tmux pane and its output."
          echo
          echo "  -c, --copy   copy to the system clipboard instead of printing"
          exit 0
          ;;
        *)
          echo "lo: unknown option: $1" >&2
          exit 2
          ;;
      esac
      shift
    done

    if [ -z "''${TMUX:-}" ]; then
      echo "lo: not running inside tmux" >&2
      exit 1
    fi

    # Glyph the zsh theme (robbyrussell) starts its prompt with. Only used by
    # the fallback below; override it when a pane runs a different prompt.
    prompt_pattern="''${LO_PROMPT_PATTERN:-➜}"

    # `run-shell` hands us the pane in TMUX_PANE; without it tmux would pick the
    # pane the client currently has active, which is not necessarily this one.
    capture() {
      if [ -n "''${TMUX_PANE:-}" ]; then
        ${tmux} capture-pane -t "$TMUX_PANE" "$@"
      else
        ${tmux} capture-pane "$@"
      fi
    }

    # -J pads every line out to the pane width, and blank lines around the
    # output are just noise.
    trim() {
      ${sed} -e 's/[[:space:]]*$//' |
        ${awk} '
          { line[NR] = $0 }
          END {
            first = 1
            last = NR
            while (first <= last && line[first] == "") first++
            while (last >= first && line[last] == "") last--
            for (i = first; i <= last; i++) print line[i]
          }
        '
    }

    last_output() {
      # Preferred path: shell integration. zsh marks the start of every prompt
      # (OSC 133;A) and tmux >= 3.7 reports those marks as the `P` line flag of
      # `capture-pane -F`. That gives us the exact region instead of a guess, so
      # it survives output containing the prompt glyph, multi-line prompts,
      # wrapped command lines, `clear` and full-screen programs.
      #
      # What we want always starts at the second to last prompt: called from the
      # tmux binding the last prompt is the one waiting for input, and called as
      # a command the last prompt is the one that started `lo` itself.
      marks=$(capture -p -L -F -S - 2>/dev/null | ${awk} '
        $1 ~ /^-?[0-9]+$/ && $2 ~ /P/ { previous = current; current = $1; prompts++ }
        END {
          if (prompts == 0) { print "unmarked"; exit }
          if (prompts < 2) { print "empty"; exit }
          print "marks", previous, current - 1
        }
      ')

      # shellcheck disable=SC2086
      set -- $marks

      case "''${1:-}" in
        marks)
          capture -p -J -S "$2" -E "$3" | trim
          return 0
          ;;
        empty)
          return 0
          ;;
      esac

      # Fallback for panes tmux has no marks for: an older tmux server, or a
      # shell without the integration (a remote host over ssh, a root shell...).
      # Everything between the last two prompt lines is the last command.
      capture -p -J -S - | ${awk} -v pattern="$prompt_pattern" '
        { line[NR] = $0 }
        index($0, pattern) { previous = current; current = NR }
        END {
          if (current == "" || previous == "") exit 1
          for (i = previous; i < current; i++) print line[i]
        }
      ' | trim
    }

    if [ "$copy" -eq 0 ]; then
      last_output
      exit 0
    fi

    extracted_output=$(last_output)

    if [ -z "$extracted_output" ]; then
      ${tmux} display-message "nothing to capture"
      exit 0
    fi

    printf '%s\n' "$extracted_output" | ${clipboard}
    lines=$(printf '%s\n' "$extracted_output" | ${wc} -l | ${sed} 's/[^0-9]//g')
    ${tmux} display-message "copied $lines line(s) to the clipboard"
  '';
}
