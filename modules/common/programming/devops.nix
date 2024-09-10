{ config, pkgs, lib, ... }: {

  options.devops.enable = lib.mkEnableOption "DevOps tools.";

  config = lib.mkIf config.devops.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        # docker desktop drop in replacement
        colima
        docker-client
        docker-compose
        kind # k8s in docker

        # kubernetes
        kubernetes-helm # helm
        kubectl # k8s cli
        kubectx # switch between k8s contexts

        # cloud cli tools
        awscli2
        aws-sam-cli

        # terraform
        tenv # version manager for opentofu, terraform, terragrunt
        tflint
        trivy # security scanner
        infracost # cost estimation for terraform

        # easier nix shell - but never as great
        devbox
      ];

      programs.zsh = {
        initExtra = ''
          # Set up completions for terragrunt
          complete -o nospace -C ${pkgs.tenv}/bin/terragrunt -C ${pkgs.tenv}/bin/terraform terragrunt
        '';

        shellAliases = {
          dockerup = "colima start";

          tg = "terragrunt";

          ka = "kubectl apply -f";
          kd = "kubectl --dry-run=client -o yaml";
        };
      };
    };
  };

}
