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
        (lib.mkIf config.ai.enable pkgs.gh-copilot) # cli extension
      ];

      gitCredentialHelper.enable = true;
    };
  };
}
