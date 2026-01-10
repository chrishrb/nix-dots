inputs: _final: prev: {
  vimPlugins = prev.vimPlugins.extend (
    final': prev': {
      codecompanion-nvim = prev.vimUtils.buildVimPlugin {
        pname = "codecompanion.nvim";
        version = "unstable";
        src = inputs.codecompanion-nvim;
        dependencies = [ prev'.plenary-nvim ];
        nvimRequireCheck = "codecompanion";
      };
      codecompanion-history-nvim = prev.vimUtils.buildVimPlugin {
        pname = "codecompanion-history.nvim";
        version = "unstable";
        src = inputs.codecompanion-history-nvim;
        nvimSkipModules = [
          "codecompanion._extensions.history.ui"
          "codecompanion._extensions.history.title_generator"
          "codecompanion._extensions.history.summary_generator"
        ];
      };
      nvim-tmux-navigation = prev.vimUtils.buildVimPlugin {
        pname = "nvim-tmux-navigation";
        version = "unstable";
        src = inputs.nvim-tmux-navigation;
      };
      nvim-nio = prev.vimUtils.buildVimPlugin {
        pname = "nvim-nio";
        version = "unstable";
        src = inputs.nvim-nio;
      };
      none-ls-extras-nvim = prev.vimUtils.buildVimPlugin {
        pname = "none-ls-extras.nvim";
        version = "unstable";
        src = inputs.none-ls-extras-nvim;
        dependencies = [ prev'.none-ls-nvim ];
      };
      nvim-tree-lua = prev.vimUtils.buildVimPlugin {
        pname = "nvim-tree.lua";
        version = "unstable";
        src = inputs.nvim-tree-lua;
        nvimSkipModules = [
          # Meta can't be required
          "nvim-tree._meta.api"
          "nvim-tree._meta.api_decorator"
        ];
      };
      mcphub-nvim = inputs.mcphub-nvim.packages.${prev.system}.default;
      garbage-day-nvim = prev.vimUtils.buildVimPlugin {
        pname = "garbage-day.nvim";
        version = "unstable";
        src = inputs.garbage-day-nvim;
        dependencies = [ prev'.nvim-lspconfig ];
      };

      # nvim-tresitter was completely rewritten, so this breaks the config currently
      nvim-treesitter = inputs.nixpkgs-stable.legacyPackages.${prev.system}.vimPlugins.nvim-treesitter;
    }
  );
}
