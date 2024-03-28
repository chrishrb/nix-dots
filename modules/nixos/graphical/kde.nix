{ config, lib, ... }: {

  config = lib.mkIf config.gui.enable {

    # Enable the X11 windowing system
    services.xserver = {
      enable = config.gui.enable;

      # Enable touchpad support
      libinput.enable = true;

      # Enable kde plasma5
      displayManager = {
        sddm.enable = true;
        plasma5.enable= true;
      };

    };

  };
}
