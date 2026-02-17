{
  config,
  ...
}:
{
  config = {
    home-manager.users.${config.user} = {
      age = {
        secrets = {
          github = {
            file = ../../../secrets/github.age;
          };
          claude = {
            file = ../../../secrets/claude.age;
          };
          context7 = {
            file = ../../../secrets/context7.age;
          };
          grafana = {
            file = ../../../secrets/grafana.age;
          };
        };

        identityPaths = [ "${config.sshKeyPath}" ];
        secretsDir = "${config.homePath}/.local/share/agenix/agenix";
        secretsMountPoint = "${config.homePath}/.local/share/agenix/agenix.d";
      };

      # unset __HM_SESS_VARS_SOURCED && source ~/.zshenv
      home.sessionVariables = {
        CLAUDE_CODE_OAUTH_TOKEN = "$(cat ${
          config.home-manager.users.${config.user}.age.secrets.claude.path
        })";
      };
    };
  };
}
