{ config, ... }:
{
  home-manager.users.${config.user} = {
    programs.mise = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}
