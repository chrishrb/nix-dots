# The laptop0997 config
# System configuration for my work macbook

{ inputs, globals, overlays, ... }:

inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs; };
  modules = [
    ../../modules/common
    ../../modules/darwin
    (globals // {
      user = "cherb";
    })
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    {
      nixpkgs.overlays = overlays;

      # Darwin specific
      networking.hostName = "laptop0997";
      identityFile = "/Users/cherb/.ssh/id_rsa";

      # Turn on all features related to desktop and graphical apps
      gui.enable = true;

      # Programs and services
      alacritty.enable = true;
      nixlang.enable = true;
      python.enable = true;
      lua.enable = true;
      slack.enable = false;
    }
  ];
}
