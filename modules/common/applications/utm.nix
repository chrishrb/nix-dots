{ config, pkgs, lib, ... }: {

  options = {
    utm = {
      enable = lib.mkEnableOption {
        description = "Enable utm.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.utm.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ utm ];
    };
  };

}
