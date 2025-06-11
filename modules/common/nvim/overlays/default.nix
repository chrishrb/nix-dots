inputs: _final: prev: {
  vimPlugins = prev.vimPlugins.extend (
    final': prev': {
      codecompanion-nvim = prev.vimUtils.buildVimPlugin {
        pname = "codecompanion.nvim";
        version = "2024-09-16";
        src = inputs.codecompanion-nvim;
        dependencies = [ prev'.plenary-nvim ];
        nvimRequireCheck = "codecompanion";
      };
      codecompanion-history-nvim = prev.vimUtils.buildVimPlugin {
        pname = "codecompanion-history.nvim";
        version = "2024-09-16";
        src = inputs.codecompanion-history-nvim;
        nvimSkipModules = [
          "codecompanion._extensions.history.ui"
          "codecompanion._extensions.history.title_generator"
        ];
      };
      nvim-tmux-navigation = prev.vimUtils.buildVimPlugin {
        pname = "nvim-tmux-navigation";
        version = "2024-03-26";
        src = inputs.nvim-tmux-navigation;
      };
      nvim-nio = prev.vimUtils.buildVimPlugin {
        pname = "nvim-nio";
        version = "2024-03-26";
        src = inputs.nvim-nio;
      };
      none-ls-extras-nvim = prev.vimUtils.buildVimPlugin {
        pname = "none-ls-extras.nvim";
        version = "2025-04-07";
        src = inputs.none-ls-extras-nvim;
        dependencies = [ prev'.none-ls-nvim ];
      };
      nvim-tree-lua = prev.vimUtils.buildVimPlugin {
        pname = "nvim-tree.lua";
        version = "2025-04-07";
        src = inputs.nvim-tree-lua;
        nvimSkipModules = [
          # Meta can't be required
          "nvim-tree._meta.api"
          "nvim-tree._meta.api_decorator"
        ];
      };
      mcphub-nvim = inputs.mcphub-nvim.packages.${prev.system}.default;
    }
  );
  mcp-hub = inputs.mcp-hub.packages.${prev.system}.default;
}
