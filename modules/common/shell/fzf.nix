{ config, pkgs, ... }: {

  home-manager.users.${config.user} = {
    programs.fzf.enable = true;
  };
}
