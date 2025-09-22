{ pkgs, config, ... }:
let
  urldecode = pkgs.writeShellScriptBin "urldecode" ''
    # urldecode <string>

    local url_encoded="''${1//+/ }"
    printf '%b' "''${url_encoded//%/\\x}"
  '';
in
{
  config = {
    home-manager.users.${config.user}.home.packages = [
      urldecode
    ];
  };
}
