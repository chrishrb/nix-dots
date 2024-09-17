{ config, pkgs, lib, ... }: {

  options.colima.enable = lib.mkEnableOption "Docker drop-in replacement.";

  config = lib.mkIf config.colima.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        # docker desktop drop in replacement
        colima
        docker-client
        docker-compose
        kind # k8s in docker
      ];

      home.file."./.colima/default/colima.yaml" = {
        source = ./colima.yaml;
      };
    };
  };
}
