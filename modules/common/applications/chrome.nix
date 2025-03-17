{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    chrome = {
      enable = lib.mkEnableOption {
        description = "Enable Chrome.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.chrome.enable) {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ google-chrome ];
    };
  };

}
