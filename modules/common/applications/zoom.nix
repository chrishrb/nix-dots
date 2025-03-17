{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    zoom = {
      enable = lib.mkEnableOption {
        description = "Enable Zoom.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.zoom.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ zoom-us ];
    };
  };

}
