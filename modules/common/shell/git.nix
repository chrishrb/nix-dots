{ config, pkgs, lib, ... }: {

  options = {
    gitName = lib.mkOption {
      type = lib.types.str;
      description = "Name to use for git commits";
    };
    gitEmail = lib.mkOption {
      type = lib.types.str;
      description = "Email to use for git commits";
    };
    gitWorkEmail = lib.mkOption {
      type = lib.types.str;
      description = "Work email to use for git commits in work directory";
    };
  };

  config = {
    home-manager.users.root.programs.git = {
      enable = true;
      extraConfig.safe.directory = config.dotfilesPath;
    };

    home-manager.users.${config.user} = {
      programs.git = {
        enable = true;
        userName = config.gitName;
        userEmail = config.gitEmail;
        aliases = {
          co = "checkout";
          ci = "commit";
          cia = "commit --amend";
          s = "status";
          st = "status";
          b = "branch";
          # p = "pull --rebase";
          pu = "push";

          ls = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate";
          ll = "log --pretty=format:\"%C(yellow)%h%Cred%d\\ %Creset%s%Cblue\\ [%cn]\" --decorate --numstat";
          lg = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)'";
          lga = "log --graph --abbrev-commit --decorate --date=relative --format=format:'%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all";
          graph = "log --graph --decorate --pretty=oneline --abbrev-commit";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
          me = "config user.name";
          count-lines = "! git log --author=\"$1\" --pretty=tformat: --numstat | awk '{ add += $1; subs += $2; loc += $1 - $2 } END { printf \"added lines: %s, removed lines: %s, total lines: %s\\n\", add, subs, loc }' #";

          # all commits today for only me
          today = "!git all --since='12am' --committer=\"`git me`\"";

          # dad instead of add
          dad = "!curl https://icanhazdadjoke.com/ && echo";
        };
        ignores = [ "*~" "*.swp" ".DS_Store" ];
        delta = {
          enable = true;
          options = {
            features = "decorations";
            navigate = true;
            light = false;
            side-by-side = true;
          };
        };
        extraConfig = {
          init.defaultBranch = "main";
          core = {
            ignorecase = false;
            autocrlf = false;
          };
          #protocol.keybase.allow = "always";
          #credential.helper = "store --file ~/.git-credentials";
          pull.rebase = "true";
          color = {
            ui = true;
            branch = "auto";
            diff = "auto";
            interactive = true;
            status = "auto";
          };
          push = {
            autoSetupRemote = true;
          };
          mergetool = {
            prompt = false;
          };
          rerere = {
            enabled = false;
            autoupdate = false;
          };
        };
        # use work email if commiting in work directory
        includes = [
          {
            path = pkgs.writeText ".gitconfig"
              ''
              [user]
                  email = ${config.gitWorkEmail}
              '';
            condition = "gitdir:${config.homePath}/dev/work/";
          }
        ];
        hooks = {
          # TODO: fix this
          # prepare-commit-msg = pkgs.writeScript "prepare-commit-msg"
          #   ''
          #   #!/bin/bash
          #
          #   COMMIT_MSG_FILE=$1
          #   COMMIT_SOURCE=$2
          #   SHA1=$3
          #
          #   ${pkgs.ai-commit}/bin/ai-commit hook "$COMMIT_MSG_FILE" "$COMMIT_SOURCE" "$SHA1"
          #   '';
        };
      };

      programs.lazygit = {
        enable = true;
        settings = {
          # This looks better with the kitty theme.
          gui.theme = {
            lightTheme = false;
            activeBorderColor = [ "white" "bold" ];
            inactiveBorderColor = [ "white" ];
            selectedLineBgColor = [ "reverse" "white" ];
          };
        };
      };
    };
  };
}

