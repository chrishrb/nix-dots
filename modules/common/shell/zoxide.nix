{ config, pkgs, ... }:
{
  home-manager.users.${config.user} = {
    home.packages = with pkgs; [
      # Smart alternative to `cd` that remembers directories
      zoxide
    ];

    # Initialize zoxide for the shell but NOT for claude
    programs.zsh.initContent = ''
      if [[ "$CLAUDECODE" != "1" ]]; then
        eval "$(${pkgs.zoxide}/bin/zoxide init zsh --cmd=cd)"
      fi
    '';
  };
}
