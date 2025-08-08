{ config, lib, ... }:
{

  imports = [
    ./wm.nix
    ./waybar.nix
    ./fonts.nix
  ];

  config = lib.mkIf config.gui.enable {

    # control brightness
    programs.light.enable = true;

    services = {
      # Enable touchpad support
      libinput.enable = true;
    };
  };
}
