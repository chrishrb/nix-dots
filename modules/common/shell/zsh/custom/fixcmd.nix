{ pkgs, ... }:
let
  fixcmd = pkgs.writeShellScriptBin "fixcmd" ''
    set -e
    ${pkgs.print-last-output}/bin/print-last-output \
    | ${pkgs.mods}/bin/mods -q -f 'analyze the following CLI output to identify the problem and suggest a possible fix.' \
    | ${pkgs.glow}/bin/glow -p -
  '';
in
{
  environment.systemPackages = [ fixcmd ];
}
