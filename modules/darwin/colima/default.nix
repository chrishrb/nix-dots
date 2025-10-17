{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.colima.enable = lib.mkEnableOption "Docker drop-in replacement.";

  config = lib.mkIf (config.colima.enable && pkgs.stdenv.isDarwin) {

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

      programs.zsh.shellAliases.dockerup = "colima start";
    };

    launchd.daemons.colima-docker-compat = {
      script = ''
        # Wait for the docker socket to be created. This is important when
        # we enabled Colima and Docker compatability at the same time, for
        # the first time. Colima takes a while creating the VM.
        until [ -S ${config.homePath}/.colima/default/docker.sock ]
        do
          sleep 5
        done
        chmod g+rw ${config.homePath}/.colima/default/docker.sock
        ln -sf ${config.homePath}/.colima/default/docker.sock /var/run/docker.sock
      '';

      serviceConfig = {
        RunAtLoad = true;
        EnvironmentVariables.PATH = "/usr/bin:/bin:/usr/sbin:/sbin";
      };
    };
  };
}
