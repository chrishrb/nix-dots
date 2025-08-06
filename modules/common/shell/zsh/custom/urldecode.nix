{ pkgs, ... }:
let
  urldecode = pkgs.writeShellScriptBin "urldecode" ''
    # urldecode <string>

    local url_encoded="''${1//+/ }"
    printf '%b' "''${url_encoded//%/\\x}"
  '';
in
{
  environment.systemPackages = [ urldecode ];
}
