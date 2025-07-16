{ config, ... }:
{
  home-manager.users.${config.user} = {
    # Smart alternative to `cd` that remembers directories
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
      options = [ "--cmd=cd" ];
    };
  };
}
