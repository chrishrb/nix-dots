{
  config,
  ...
}:
{
  config = {
    home-manager.users.${config.user} = {
      age = {
        secrets = {
          github-secret = {
            file = ../../../secrets/github-secret.age;
          };
        };

        identityPaths = [ "${config.sshKeyPath}" ];
        secretsDir = "${config.homePath}/.local/share/agenix/agenix";
        secretsMountPoint = "${config.homePath}/.local/share/agenix/agenix.d";
      };

      home.sessionVariables = {
        GITHUB_PERSONAL_ACCESS_TOKEN = "$(cat ${
          config.home-manager.users.${config.user}.age.secrets.github-secret.path
        })";
      };
    };
  };
}
