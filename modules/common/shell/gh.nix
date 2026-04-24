{
  lib,
  config,
  pkgs,
  ...
}:
{

  home-manager.users.${config.user} = {
    home.packages = with pkgs; [
      (lib.mkIf config.ai.enable github-copilot-cli) # copilot cli extension
    ];

    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
