{ pkgs, ... }:
let
  mktar = pkgs.writeShellScriptBin "mktar" ''
    tar -czvf "$@"
  '';
in
{
  environment.systemPackages = [ mktar ];
}
