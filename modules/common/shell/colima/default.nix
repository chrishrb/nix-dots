{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.colima.enable = lib.mkEnableOption "Docker drop-in replacement.";

  config = lib.mkIf config.colima.enable {

    environment.variables = {
      DOCKER_HOST = "unix://$HOME/.colima/default/docker.sock";
    };

    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        # docker desktop drop in replacement
        colima
        docker-client
        docker-compose
        kind # k8s in docker
      ];

      home.file."./.colima/_templates/default.yaml" = {
        source = ./colima.yaml;
        onChange = ''mkdir -p ~/.colima/default/ && cat ~/.colima/_templates/default.yaml > ~/.colima/default/colima.yaml'';
      };
    };
  };
}
