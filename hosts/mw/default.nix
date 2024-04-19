# The mw config
# System configuration for my work macbook

{ inputs, globals, overlays, ... }:

inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs; };
  modules = [
    ../../modules/common
    ../../modules/darwin
    (globals // {
      user = "christoph.herb";
    })
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nixpkgs.overlays = overlays;

      # Darwin specific
      networking.hostName = "MB-GDWLXJMCPF";

      # Turn on all features related to desktop and graphical apps
      gui.enable = true;

      # Programs and services
      alacritty.enable = true;
      chrisNvim.enable = true;
      dotfiles.enable = true;

      # languaages
      python.enable = true;
      lua.enable = true;
      devops.enable = true;
      go.enable = true;
      java.enable = true;
      web.enable = true;
      ai.enable = true;
      discord.enable = true;
    }
  ];
}
