{ config, lib, ... }: {

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
        plasma5.enable= true;
      };

    };

  };
}
