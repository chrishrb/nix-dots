{ pkgs, config, ... }:
{

  config = {

    services.xserver = {

      xkb = {
        layout = "programming-de";
        #options = "altwin:ctrl_alt_win";
        extraLayouts.programming-de = {
          description = "Programming de keyboard layout";
          languages = [ "de" ];
          symbolsFile = pkgs.writeText "xkb-layout" ''
            xkb_symbols "programming-de"
            {
              include "de(mac_nodeadkeys)"

              key <AD11> { [ bar, asciitilde, udiaeresis, Udiaeresis ] };
              key <AC10> { [ bracketleft, braceleft, odiaeresis, Odiaeresis ] };
              key <AC11> { [ bracketright, braceright, adiaeresis, Adiaeresis ] };
            };
          '';
        };
      };

      # Keyboard responsiveness
      autoRepeatDelay = 250;
      autoRepeatInterval = 40;

    };

    # Enable num lock on login
    home-manager.users.${config.user}.xsession.numlock.enable = true;

    # Configure console keymap
    #console.keyMap = "programming-de";

  };

}
