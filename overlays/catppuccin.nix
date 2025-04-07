# INFO: catppuccin tmux changed a lot in the last release and doesnt work anymore like before
inputs: _final: prev: {
  tmuxPlugins = prev.tmuxPlugins // {
    catppuccin = inputs.nixpkgs-stable.legacyPackages.${prev.system}.tmuxPlugins.catppuccin;
  };
}
