{
  pkgs,
  lib,
  config,
  ...
}:
let
  cmdfix = pkgs.writeShellScriptBin "cmdfix" ''
    set -e
    ${pkgs.print-last-output}/bin/print-last-output \
    | ${pkgs.mods}/bin/mods -f 'analyze the following CLI output to identify the problem and suggest a possible fix.'
  '';
in
{
  config = lib.mkIf config.ai.enable {
    home-manager.users.${config.user}.home.packages = [
      cmdfix
    ];
  };
}
