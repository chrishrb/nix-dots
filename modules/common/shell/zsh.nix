{
  lib,
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
          (lib.mkIf config.python.enable { name = "MichaelAquilina/zsh-autoswitch-virtualenv"; })
          {
            name = "zsh-users/zsh-syntax-highlighting";
            tags = [ "defer:2" ];
          }
          { name = "zsh-users/zsh-autosuggestions"; }
          { name = "zsh-users/zsh-completions"; }
          (lib.mkIf config.ai.enable {
            name = "chrishrb/zsh-claude";
            tags = [ "at:main" ];
          })
          (lib.mkIf config.ruby.enable {
            name = "plugins/rbenv";
            tags = [
              "from:oh-my-zsh"
              "lazy:true"
            ];
          })
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
        t = "klog";

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

        # Fix "too many open files" issue on macos
        ulimit -n 4096
      '';
      sessionVariables = {
        LANG = "en_US.UTF-8";
        LC_ALL = "en_US.UTF-8";
      };
      initContent = ''
        # TODO: remove after resolving: https://github.com/NixOS/nixpkgs/issues/275770
        # awscli2 workaround
        if command -v aws_completer &>/dev/null; then
          complete -C "$(command -v aws_completer)" aws
        fi

        # make sure brew is on the path for M1
        if [[ $(uname -m) == 'arm64' ]]; then
          eval "$(/opt/homebrew/bin/brew shellenv)"
        fi

        # Shell integration (OSC 133): mark where a prompt starts and where a
        # command's output begins. tmux turns these into line flags, which is
        # how `lo` (and prefix + y) find the last command and its output without
        # guessing at the shape of the prompt. The prompt mark has to be part of
        # PROMPT itself — printing it from precmd gets wiped when zle redraws the
        # line — and it is prepended lazily so it lands after zplug has loaded
        # the theme.
        autoload -Uz add-zsh-hook
        _osc133_precmd() {
          [[ $PROMPT == *$'\e]133;A'* ]] || PROMPT=$'%{\e]133;A\e\\%}'$PROMPT
        }
        _osc133_preexec() { print -n $'\e]133;C\e\\' }
        add-zsh-hook precmd _osc133_precmd
        add-zsh-hook preexec _osc133_preexec
      ''
      + (
        if config.ai.enable then
          ''
            bindkey '^[e' zsh_claude_explain  # bind ALT+E to explain
            bindkey '^[s' zsh_claude_suggest  # bind ALT+S to suggest

            # `fuck` — open claude on the command that just failed, with the
            # command and its output already in the prompt.
            fuck() {
              local context
              context=$(lo) || return $?
              if [[ -z $context ]]; then
                print -u2 "fuck: no command to fix"
                return 1
              fi
              claude "The last command in my shell failed. Work out why and fix it.

            $context"
            }
          ''
        else
          ""
      );
    };
  };
}
