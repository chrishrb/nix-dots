inputs: _final: prev:
let
  print-last-output = prev.writeShellScriptBin "print-last-output" ''
    PROMPT_PATTERN="➜"

    tmux_output=$(${prev.tmux}/bin/tmux capture-pane -p -S '-' -J)

    echo "$tmux_output" | ${prev.coreutils}/bin/tac |
      ${prev.gnused}/bin/sed -e "0,/$PROMPT_PATTERN/d" |
      ${prev.gnused}/bin/sed "/$PROMPT_PATTERN/,\$d" |
      ${prev.coreutils}/bin/tac
  '';
in
{
  inherit print-last-output;

  capture-last-output = prev.writeShellScriptBin "capture-last-output" ''
    extracted_output=$(${print-last-output}/bin/print-last-output)

    ${
      if prev.stdenv.isDarwin then
        "echo \"$extracted_output\" | pbcopy"
      else
        "echo \"$extracted_output\" | ${prev.xclip}/bin/xclip -selection clipboard"
    }
  '';
}
