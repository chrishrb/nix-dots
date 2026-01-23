{
  lib,
  config,
  pkgs,
  ...
}:
{

  home-manager.users.${config.user} = {
    programs.gh = {
      enable = true;

      extensions = [
        (lib.mkIf config.ai.enable pkgs.github-copilot-cli) # cli extension
      ];

      gitCredentialHelper.enable = true;
    };
  };
}
