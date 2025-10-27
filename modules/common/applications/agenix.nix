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
          gemini = {
            file = ../../../secrets/gemini.age;
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

      home.sessionVariables = {
        GEMINI_API_KEY = "$(cat ${config.home-manager.users.${config.user}.age.secrets.gemini.path})";
      };
    };
  };
}
