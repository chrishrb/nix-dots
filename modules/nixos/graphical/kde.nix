{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf config.gui.enable {

    # Enable the X11 windowing system
    services.xserver = {
      enable = config.gui.enable;

      # Enable touchpad support
      libinput.enable = true;

      # Enable login screen
      displayManager = {
        sddm.enable = true;
      };

      # Enable kde plasma5
      desktopManager = {
        plasma5.enable = true;
      };

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
