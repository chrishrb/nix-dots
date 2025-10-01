{
  lib,
  config,
  ...
}:
{
  config = lib.mkIf config.work.enable {

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
          export GH_ACCESS_TOKEN=${config.home-manager.users.${config.user}.age.secrets.github.path}

          # AWS login to staging
          function staging() {
            export AWS_PROFILE=staging && aws sso login --profile staging
            export GIPEDO_ENVIRONMENT=staging
            export GIPEDO_USER_TYPE=employee
            export GIPEDO_EMAIL=$(cat ~/.gipedo/email)
            export GIPEDO_PASSWORD=$(cat ~/.gipedo/staging)
            export AGON_SERVICE_ACCOUNT_USERNAME=$GIPEDO_EMAIL
            export AGON_SERVICE_ACCOUNT_PASSWORD=$GIPEDO_PASSWORD
          }

          function infrastructure() {
            export AWS_PROFILE=infrastructure && aws sso login --profile infrastructure
            export GIPEDO_ENVIRONMENT=infrastructure
          }

          # AWS login to production
          function production() {
            export AWS_PROFILE=production && aws sso login --profile production
            export GIPEDO_ENVIRONMENT=production
            export GIPEDO_USER_TYPE=employee
            export GIPEDO_EMAIL=$(cat ~/.gipedo/email)
            export GIPEDO_PASSWORD=$(cat ~/.gipedo/production)
            export AGON_SERVICE_ACCOUNT_USERNAME=$GIPEDO_EMAIL
            export AGON_SERVICE_ACCOUNT_PASSWORD=$GIPEDO_PASSWORD
          }
        '';
      };
    };
  };
}
