# The macbook-christoph config
# System configuration for my personal macbook

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
      allowUnfree = true;

      # Darwin specific
      networking.hostName = "macbook-christoph";

      # Turn on all features related to desktop and graphical apps
      gui.enable = true;

      # Programs and services
      colima.enable = true;
      alacritty.enable = true;
      nvim.enable = true;
      dotfiles.enable = true;
      drawio.enable = false;
      utm.enable = false;
      brave.enable = true;
      discord.enable = false;

      # languaages
      python.enable = true;
      lua.enable = true;
      devops.enable = true;
      go.enable = true;
      java.enable = false;
      web.enable = true;
      ai.enable = true;
      latex.enable = true;
      nixlang.enable = true;
      flutter.enable = false;
    }
  ];
}
