{ config, lib, ... }:
{

  imports = [
    ./wm.nix
    ./waybar.nix
    ./fonts.nix
  ];

  config = lib.mkIf config.gui.enable {
    services = {
      # Enable touchpad support
      libinput.enable = true;
    };
  };
}
