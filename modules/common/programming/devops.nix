{
  config,
  pkgs,
  lib,
  ...
}:
{

  options.devops.enable = lib.mkEnableOption "DevOps tools.";

  config = lib.mkIf config.devops.enable {
    home-manager.users.${config.user} = {
      home.packages = with pkgs; [
        # kubernetes
        kubernetes-helm # helm
        kubectl # k8s cli
        kubectx # switch between k8s contexts
        fluxcd

        # talos tools
        talosctl
        talhelper

        # manage secrets
        sops
        age

        # cloud cli tools
        awscli2
        # aws-sam-cli

        # terraform
        tenv # version manager for opentofu, terraform, terragrunt
        tflint
        trivy # security scanner
        infracost # cost estimation for terraform

        # easier nix shell - but never as great
        devbox
        postman

        # expose local webservers to internet
        ngrok
        postman
      ];

      programs.zsh = {
        initContent = ''
          # Set up completions for terragrunt
          complete -o nospace -C ${pkgs.tenv}/bin/terragrunt -C ${pkgs.tenv}/bin/terraform terragrunt

          # completions for awslocal
          complete -C '${pkgs.awscli2}/bin/aws_completer' awslocal
        '';

        shellAliases = {
          dockerup = "colima start";

          tg = "terragrunt";

          ka = "kubectl apply -f";
          kd = "kubectl --dry-run=client -o yaml";
          awslocal = "aws --endpoint-url=http://localhost:4566";
        };
      };
    };
  };

}
