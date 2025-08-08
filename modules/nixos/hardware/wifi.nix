{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf pkgs.stdenv.isLinux {

    # Enables wireless support via iwd.
    networking = {
      networkmanager.enable = true;
      wireless.iwd.enable = true;

      # iwd is a modern replacement for wpa_supplicant
      networkmanager.wifi.backend = "iwd";

      # Allows the user to control the WiFi settings.
      wireless.userControlled.enable = true;
    };

  };

}
