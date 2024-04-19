{ config, pkgs, lib, ... }: {

  options = {
    discord = {
      enable = lib.mkEnableOption {
        description = "Enable Discord.";
        default = false;
      };
    };
  };

  config = lib.mkIf (config.gui.enable && config.discord.enable) {
    unfreePackages = [ "discord" ];
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [ discord ];
    };
  };

}
