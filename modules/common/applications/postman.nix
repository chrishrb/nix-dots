{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    postman = {
      enable = lib.mkEnableOption {
        description = "Enable Postman.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.postman.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ postman ];
    };
  };

}
