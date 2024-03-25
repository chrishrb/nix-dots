{ config, pkgs, lib, ... }: {

  options.node.enable = lib.mkEnableOption "NodeJS.";

  config = lib.mkIf config.node.enable {
    home-manager.users.${config.user}.home.packages = with pkgs; [
      nodejs_21
    ];
  };

}
