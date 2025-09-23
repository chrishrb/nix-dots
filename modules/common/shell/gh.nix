{ config, pkgs, ... }:
{

  home-manager.users.${config.user} = {
    programs.gh = {
      enable = true;

      extensions = [
        pkgs.gh-copilot # cli extension
      ];
    };
  };
}
