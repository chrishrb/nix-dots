{ config, pkgs, ... }:
{

  home-manager.users.${config.user} = {

    programs.tmux = {
      enable = true;
      tmuxinator.enable = true;
      plugins = with pkgs.tmuxPlugins; [
        sensible
        mode-indicator
        {
          plugin = catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'mocha'
            set -g @plugin 'catppuccin/tmux'
            set -g @catppuccin_window_tabs_enabled on
            set -g @catppuccin_window_default_text "#W"
            set -g @catppuccin_window_current_text "#W"
            set -g @catppuccin_window_left_separator ""
            set -g @catppuccin_window_right_separator " "
            set -g @catppuccin_window_middle_separator " █"
            set -g @catppuccin_window_number_position "right"
            set -g @catppuccin_status_left_separator  " "
            set -g @catppuccin_status_right_separator ""
          '';
        }
      ];
      terminal = "tmux-256color";
      prefix = "C-a";
      keyMode = "vi";
      baseIndex = 1;
      escapeTime = 10;
      mouse = true;
      historyLimit = 50000;
      extraConfig =
        let
          capture-last-cmd-output = pkgs.writeShellScriptBin "capture-last-cmd-output" ''
            PROMPT_PATTERN="➜"

            tmux_output=$(${pkgs.tmux}/bin/tmux capture-pane -p -S '-' -J)

            extracted_output=$(echo "$tmux_output" | tail -r |
              ${pkgs.gnused}/bin/sed -e "0,/$PROMPT_PATTERN/d" |
              ${pkgs.gnused}/bin/sed "/$PROMPT_PATTERN/,\$d" |
              tail -r)

            ${
              if pkgs.stdenv.isDarwin then
                "echo \"$extracted_output\" | pbcopy"
              else
                "echo \"$extracted_output\" | ${pkgs.xclip}/bin/xclip -selection clipboard"
            }'';
        in
        ''
          set -ag terminal-overrides ",xterm-256color:RGB"
          set -g pane-base-index 1
          set -g status-justify left
          set -g default-command '$SHELL'

          # don't rename windows automatically
          set-option -g allow-rename off
          set-option -g renumber-windows on

          # Remove Vim mode delays
          set -g focus-events on

          # Enable full mouse support
          set -g mouse on

          # -----------------------------------------------------------------------------
          # Key bindings
          # -----------------------------------------------------------------------------

          # Unbind default keys
          unbind C-b
          unbind '"'
          unbind %

          # mouse support
          set -g mouse on
          bind -T copy-mode-vi MouseDrag1Pane    send -X begin-selection
          bind -T copy-mode-vi MouseDragEnd1Pane send -X copy-selection-no-clear

          # vim
          bind-key -T copy-mode-vi Enter send -X copy-selection-and-cancel
          bind-key -T copy-mode-vi 'v' send -X begin-selection
          bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'reattach-to-user-namespace pbcopy'

          # split panes using | and - 
          # + open in current directory
          bind c new-window -c '#{pane_current_path}'
          bind | split-window -h -c '#{pane_current_path}'
          bind - split-window -v -c '#{pane_current_path}'

          # Smart pane switching with awareness of Vim splits.
          # This is copy paste from https://github.com/christoomey/vim-tmux-navigator
          is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
            | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?l?)(diff)?$'"
          bind-key -n 'C-h' if-shell "$is_vim" 'send-keys C-h'  'select-pane -L'
          bind-key -n 'C-j' if-shell "$is_vim" 'send-keys C-j'  'select-pane -D'
          bind-key -n 'C-k' if-shell "$is_vim" 'send-keys C-k'  'select-pane -U'
          bind-key -n 'C-l' if-shell "$is_vim" 'send-keys C-l'  'select-pane -R'
          tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
          if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
          if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
            "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

          bind-key -T copy-mode-vi 'C-h' select-pane -L
          bind-key -T copy-mode-vi 'C-j' select-pane -D
          bind-key -T copy-mode-vi 'C-k' select-pane -U
          bind-key -T copy-mode-vi 'C-l' select-pane -R
          bind-key -T copy-mode-vi 'C-\' select-pane -l

          # vim like tab switch
          bind l next-window
          bind h previous-window
          unbind p
          unbind n
          bind q confirm-before -p "kill-pane #W? (y/n)" kill-pane
          bind Q confirm-before -p "kill-window #W? (y/n)" kill-window

          # reorder tabs
          bind H swap-window -t -1\; select-window -t -1
          bind L swap-window -t +1\; select-window -t +1

          # capture last cmd output
          bind y run-shell '${capture-last-cmd-output}/bin/capture-last-cmd-output'
        '';
    };

    home.file."./.config/tmuxinator/" = {
      source = ./tmuxinator;
      recursive = true;
    };

    programs.zsh.shellAliases = {
      tm = "tmuxinator";
    };
  };
}
