inputs: _final: prev: {
  vimPlugins = prev.vimPlugins.extend (final': prev': {
    avante-nvim = inputs.nixpkgs-avante.legacyPackages.${prev.system}.vimPlugins.avante-nvim;

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
