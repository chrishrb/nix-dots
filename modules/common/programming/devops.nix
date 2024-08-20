{ config, pkgs, lib, ... }: {

  options.devops.enable = lib.mkEnableOption "DevOps tools.";

  config = lib.mkIf config.devops.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        # docker desktop drop in replacement
        colima
        docker-client
        docker-compose
        kind
        kubernetes-helm

        # cloud cli tools
        kubectl
        awscli2
        aws-sam-cli
        devbox
        kafkactl

        # terraform
        tenv # version manager for opentofu, terraform, terragrunt
        tflint
        trivy # security scanner
        infracost # cost estimation for terraform
      ];

      programs.zsh = {
        initExtra = ''
          # Set up completions for terragrunt
          complete -o nospace -C ${pkgs.tenv}/bin/terragrunt -C ${pkgs.tenv}/bin/terraform terragrunt
        '';

        shellAliases = {
          tg = "terragrunt";

          ka = "kubectl apply -f";
          kd = "kubectl --dry-run=client -o yaml";
        };
      };
    };
  };

}
