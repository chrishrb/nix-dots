# The ambush home config
# System configuration for my home pc

{ inputs, globals, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    ../../modules/common
    ../../modules/nixos
    (globals // {
      user = "christoph";
    })
    inputs.home-manager.nixosModules.home-manager
    {
      nixpkgs.overlays = overlays;

      # Hardware
      networking.hostname = "ambush";

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
