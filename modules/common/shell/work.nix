{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.work.enable {

    programs = {
      _1password.enable = true;
      _1password-gui.enable = true;
    };

    home-manager.users.${config.user} = {
      programs.zsh = {
        initContent = ''
          # AWS defaults
          export AWS_DEFAULT_REGION=eu-central-1
          export AWS_REGION=eu-central-1
          export AWS_PAGER=""

          # Golang setup
          export GOPRIVATE="github.com/gipedo/*"

          # Local token needed in environment
          export FONTAWESOME_NPM_AUTH_TOKEN=$(cat ~/.fontawesome_token)
          export GH_ACCESS_TOKEN="$(cat ${config.home-manager.users.${config.user}.age.secrets.github.path})"

          # AWS login to staging
          function staging() {
            export AWS_PROFILE=staging
            export GIPEDO_ENVIRONMENT=staging
            if ! aws sts get-caller-identity --profile staging &>/dev/null; then
              aws sso login --profile staging
            fi
            echo -e "\033[0;32mSetting up staging environment variables!\033[0m"
          }

          function infrastructure() {
            export AWS_PROFILE=infrastructure
            export GIPEDO_ENVIRONMENT=infrastructure
            if ! aws sts get-caller-identity --profile infrastructure &>/dev/null; then
              aws sso login --profile infrastructure
            fi
            echo -e "\033[0;32mSetting up infrastructure environment variables!\033[0m"
          }

          # AWS login to production
          function production() {
            export AWS_PROFILE=production
            export GIPEDO_ENVIRONMENT=production
            if ! aws sts get-caller-identity --profile production &>/dev/null; then
              aws sso login --profile production
            fi
            echo -e "\033[0;32mSetting up production environment variables!\033[0m"
          }
        '';
      };
    };
  };
}
