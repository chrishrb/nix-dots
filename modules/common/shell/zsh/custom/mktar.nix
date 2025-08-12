{ pkgs, config, ... }:
let
  mktar = pkgs.writeShellScriptBin "mktar" ''
    tar -czvf "$@"
  '';
in
{
  config = {
    home-manager.users.${config.user}.home.packages = [
      mktar
    ];
  };
}
