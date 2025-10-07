# The mw config
# System configuration for my work macbook

{
  inputs,
  globals,
  overlays,
  ...
}:

inputs.darwin.lib.darwinSystem {
  system = "aarch64-darwin";
  specialArgs = { inherit inputs; };
  modules = [
    ../../modules/common
    ../../modules/darwin
    (
      globals
      // {
        user = "christophherb";
      }
    )
    inputs.home-manager.darwinModules.home-manager
    inputs.nix-homebrew.darwinModules.nix-homebrew
    inputs.mac-app-util.darwinModules.default
    {
      nixpkgs.overlays = overlays;

      # Darwin specific
      networking.hostName = "macbook-gipedo";

      # Turn on all features related to desktop and graphical apps
      gui.enable = true;
      work.enable = true;

      # Enable ai features
      ai.enable = true;

      # Programs and services
      slack.enable = true;
      colima.enable = true;
      alacritty.enable = true;
      nvim.enable = true;
      brave.enable = true;

      # languaages
      python.enable = true;
      lua.enable = true;
      devops.enable = true;
      go.enable = true;
      web.enable = true;
      nixlang.enable = true;
    }
  ];
}
