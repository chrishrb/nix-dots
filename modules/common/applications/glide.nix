{
  config,
  pkgs,
  lib,
  ...
}:
{

  options = {
    glide = {
      enable = lib.mkEnableOption {
        description = "Enable glide browser.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.glide.enable) {
    home-manager.users.${config.user} = {
      home = {
        packages = with pkgs; [ glide-browser ];

        file."./.config/glide/glide.ts".source = ../glide/glide.ts;
      };
    };
  };
}
