{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf pkgs.stdenv.isLinux {

    # Enables wireless support via wpa_supplicant.
    networking.wireless.enable = !config.networking.networkmanager.enable;

    # Allows the user to control the WiFi settings.
    networking.wireless.userControlled.enable = true;

  };

}
