importName: inputs: let
  overlay = self: super: { 
    ${importName} = {

      # gx.nvim
      gx-nvim = super.vimUtils.buildVimPlugin {
        pname = "gx.nvim";
        version = "2024-03-26";
        src = inputs.gx-nvim;
      };

      # nvim-tmux-navigation
      nvim-tmux-navigation = super.vimUtils.buildVimPlugin {
        pname = "nvim-tmux-navigation";
        version = "2024-03-26";
        src = inputs.nvim-tmux-navigation;
      };

      # nvim-tmux-navigation
      nvim-nio = super.vimUtils.buildVimPlugin {
        pname = "nvim-nio";
        version = "2024-03-26";
        src = inputs.nvim-nio;
      };

      # nvim-tmux-navigation
      copilot-chat-nvim = super.vimUtils.buildVimPlugin {
        pname = "CopilotChat.nvim";
        version = "2024-03-26";
        src = inputs.copilot-chat-nvim;
      };

    };
  };
in
overlay
