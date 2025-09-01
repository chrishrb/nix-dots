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
        };

        identityPaths = [ "${config.sshKeyPath}" ];
        secretsDir = "${config.homePath}/.local/share/agenix/agenix";
        secretsMountPoint = "${config.homePath}/.local/share/agenix/agenix.d";
      };

      home.sessionVariables = {
        GITHUB_TOKEN = "$(cat ${config.home-manager.users.${config.user}.age.secrets.github.path})";
        GEMINI_API_KEY = "$(cat ${config.home-manager.users.${config.user}.age.secrets.gemini.path})";
      };
    };
  };
}
