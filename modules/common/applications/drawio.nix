{ config, pkgs, lib, ... }: {

  options = {
    drawio = {
      enable = lib.mkEnableOption {
        description = "Enable drawio.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.drawio.enable) {
    unfreePackages = [ "drawio" ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ drawio ];
    };
  };

}
