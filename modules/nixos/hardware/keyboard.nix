{ config, lib, ... }: {

  config = lib.mkIf config.physical {

    services.xserver = {

      layout = "de";
      xkbVariant = "applealu_iso";

      # Keyboard responsiveness
      autoRepeatDelay = 250;
      autoRepeatInterval = 40;

    };

    # Enable num lock on login
    home-manager.users.${config.user}.xsession.numlock.enable = true;

  };

}
