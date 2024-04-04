{ config, pkgs, lib, ... }: {

  options.devops.enable = lib.mkEnableOption "DevOps tools.";

  config = lib.mkIf config.devops.enable {
    home-manager.users.${config.user}.home.packages = with pkgs; [
      # docker desktop drop in replacement
      colima
      docker-client
      docker-compose
    ];
  };

}
