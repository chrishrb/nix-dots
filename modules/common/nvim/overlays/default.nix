inputs: _final: prev: {
  vimPlugins = prev.vimPlugins.extend (
    final': prev': {
      codecompanion-nvim = prev.vimUtils.buildVimPlugin {
        pname = "codecompanion.nvim";
        version = "2024-09-16";
        src = inputs.codecompanion-nvim;
        dependencies = [ prev.vimPlugins.plenary-nvim ];
        nvimRequireCheck = "codecompanion";
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
        dependencies = [ prev.vimPlugins.none-ls-nvim ];
      };
    }
  );
}
