{
  config,
  pkgs,
  ...
}:
{

  users.users.${config.user}.shell = pkgs.zsh;
  programs.zsh.enable = true;

  home-manager.users.${config.user} = {

    home.packages = with pkgs; [ curl ];

    programs.zsh = {
      enable = true;
      syntaxHighlighting.enable = true;
      defaultKeymap = "viins";
      zplug = {
        enable = true;
        plugins = [
          { name = "lukechilds/zsh-nvm"; }
          { name = "hlissner/zsh-autopair"; }
          { name = "zap-zsh/supercharge"; }
          {
            name = "themes/robbyrussell";
            tags = [
              "from:oh-my-zsh"
              "as:theme"
            ];
          }
          { name = "zap-zsh/vim"; }
          {
            name = "plugins/fzf";
            tags = [ "from:oh-my-zsh" ];
          }
          {
            name = "plugins/aws";
            tags = [
              "from:oh-my-zsh"
              "lazy:true"
            ];
          }
          {
            name = "plugins/kubectl";
            tags = [
              "from:oh-my-zsh"
              "lazy:true"
            ];
          }
          {
            name = "macunha1/zsh-terraform";
            tags = [
              "lazy:true"
            ];
          }
          {
            name = "plugins/docker";
            tags = [
              "from:oh-my-zsh"
              "lazy:true"
            ];
          }
          { name = "paulirish/git-open"; }
          { name = "MichaelAquilina/zsh-autoswitch-virtualenv"; }
          {
            name = "zsh-users/zsh-syntax-highlighting";
            tags = [ "defer:2" ];
          }
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-completions"; }
        ];
      };
      localVariables = {
        RPROMPT = "";
        VI_MODE_ESC_INSERT = "jj";
        DISABLE_UNTRACKED_FILES_DIRTY = "true";
        FZF_DEFAULT_OPTS = "
          --layout=reverse
          --info=inline
          --height=80%
          --multi
          --preview-window=:hidden
          --preview '([[ -f {} ]] && (bat --style=numbers --color=always {} || cat {})) || ([[ -d {} ]] && (tree -C {} | less)) || echo {} 2> /dev/null | head -200'
          --color='hl:148,hl+:154,pointer:032,marker:010,bg+:237,gutter:008'
          --bind '?:toggle-preview'
          --bind 'ctrl-a:select-all'
          --bind 'ctrl-y:execute-silent(echo {+} | pbcopy)'
          --bind 'ctrl-e:execute(echo {+} | vim -)'
          --bind 'ctrl-k:up,ctrl-j:down'
          ";
        # nvm options
        NVM_COMPLETION = true;
        NVM_LAZY_LOAD = true;
        NVM_AUTO_USE = true;
      };
      shellAliases = {
        ## navigation aliases
        dev = "cd ~/dev/";
        home = "cd ~/dev/home/";
        work = "cd ~/dev/work/";

        ## other
        du = "du -sh";
        df = "df -h";
        copy = "pbcopy";
        grep = "rg";
        ls = "ls --color=auto";

        ## vim,tmux,zsh
        ssh = "TERM=xterm-256color ssh"; # needed for ssh to work properly
      };
      completionInit = ''
        autoload -Uz compinit
        compinit -C
      '';
      profileExtra = ''
        setopt correct                                                  # Auto correct mistakes
        setopt numericglobsort                                          # Sort filenames numerically when it makes sense
        zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
        zstyle ':completion:*' list-colors "''${(s.:.)LS_COLORS}"       # Colored completion (different colors for dirs/files/etc)
        zstyle ':completion:*' rehash true                              # automatically find new executables in path

        # Speed up completions
        zstyle ':completion:*' use-cache on
        zstyle ':completion:*' cache-path ~/.zsh/cache
      '';
      sessionVariables = { };
      initContent = ''
        # make sure brew is on the path for M1 
        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
      '';
    };
  };
}
