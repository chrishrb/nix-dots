{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    brave = {
      enable = lib.mkEnableOption {
        description = "Enable Brave.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.brave.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ brave ];
    };
  };

}
