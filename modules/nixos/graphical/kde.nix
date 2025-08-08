{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.gui.enable {

    services = {

      # Enable login screen
      displayManager = {
        sddm.enable = true;
      };

      # Enable the X11 windowing system
      xserver.enable = true;

      # Enable kde plasma6
      desktopManager = {
        plasma6.enable = true;
      };

      # Enable touchpad support
      libinput.enable = true;
    };

    environment.systemPackages = with pkgs; [ xclip ];

    home-manager.users.${config.user} = {
      programs.zsh.shellAliases = {
        pbcopy = "xclip -selection clipboard -in";
        pbpaste = "xclip -selection clipboard -out";
      };
    };

  };
}
