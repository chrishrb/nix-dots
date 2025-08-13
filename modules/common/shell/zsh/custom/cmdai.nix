{
  pkgs,
  config,
  lib,
  ...
}:
let
  vipe = pkgs.writeShellScriptBin "vipe" ''
    #
    # vipe(1) - Pipe in and out of $EDITOR
    #
    # (c) 2014 Julian Gruber <julian@juliangruber.com>
    # (c) 2025 chrishrb <52382992+chrishrb@users.noreply.github.com>
    # MIT licensed.
    #
    # Example:
    #
    #   $ echo foo | vipe | gist
    #   $ vipe | gist
    #
    # This is a lightweight shell only version. For the original impementation in
    # perl, check https://github.com/madx/moreutils/blob/master/vipe
    #

    # version
    VERSION="0.1.1"

    # usage
    if [ "''${1}" ]; then
      case "''${1}" in
      "-h")
        echo "usage: vipe [-hV]"
        exit 0 ;;
      "-V")
        echo "$VERSION"
        exit 0 ;;
      *)
        echo "unknown option: \"''${1}\""
        echo "usage: vipe [-hV]"
        exit 1
      esac
    fi

    # temp files
    t=$(${pkgs.mktemp}/bin/mktemp /tmp/vipe.XXXXXX.txt)
    orig=$(${pkgs.mktemp}/bin/mktemp /tmp/vipe.orig.XXXXXX.txt)

    # read from stdin
    if [ ! -t 0 ]; then
      cat > "$t"
    fi

    # Save original contents
    cp "$t" "$orig"

    # spawn editor with stdio connected
    "$EDITOR" "$t" < /dev/tty > /dev/tty || exit $?

    # check for changes
    if cmp -s "$t" "$orig"; then
      rm "$t" "$orig"
      exit 1
    fi

    # write to stdout
    cat "$t"

    # cleanup
    rm "$t" "$orig"
  '';

  cmdai = pkgs.writeShellScriptBin "cmdai" ''
    ${pkgs.mods}/bin/mods "command to ''$*. only the command, no explanations, no formatting, no surrounding backticks, remove surrounding codeblocks, replace specific directories with placeholders formatted as {{ placeholder }}" |
      ${vipe}/bin/vipe |
      tee -a /dev/tty |
      bash
  '';
in
{
  config = lib.mkIf config.ai.enable {
    home-manager.users.${config.user}.home.packages = [
      cmdai
    ];
  };
}
