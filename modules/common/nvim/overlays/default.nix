inputs: _final: prev: {
  vimPlugins = prev.vimPlugins.extend (final': prev': {
    # codecompanion ai
    codecompanion-nvim = prev.vimUtils.buildVimPlugin {
      pname = "codecompanion.nvim";
      version = "2024-09-16";
      src = inputs.codecompanion-nvim;
    };
    dressing-nvim = prev.vimUtils.buildVimPlugin {
      pname = "dressing.nvim";
      version = "2024-09-13";
      src = inputs.dressing-nvim;
    };
    mini-diff = prev.vimUtils.buildVimPlugin {
      pname = "mini.diff";
      version = "2024-09-13";
      src = inputs.mini-diff;
    };

    # gx.nvim
    gx-nvim = prev.vimUtils.buildVimPlugin {
      pname = "gx.nvim";
      version = "2024-03-26";
      src = inputs.gx-nvim;
    };

    # nvim-tmux-navigation
    nvim-tmux-navigation = prev.vimUtils.buildVimPlugin {
      pname = "nvim-tmux-navigation";
      version = "2024-03-26";
      src = inputs.nvim-tmux-navigation;
    };

    # nvim-tmux-navigation
    nvim-nio = prev.vimUtils.buildVimPlugin {
      pname = "nvim-nio";
      version = "2024-03-26";
      src = inputs.nvim-nio;
    };
  });
}
