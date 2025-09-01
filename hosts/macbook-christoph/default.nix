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

      # Darwin specific
      networking.hostName = "macbook-christoph";

      # Turn on all features related to desktop and graphical apps
      gui.enable = true;

      # Enable ai features
      ai = {
        enable = true;
        provider = "gemini";
        model = "gemini-2.5-pro";
      };

      # Programs and services
      colima.enable = true;
      alacritty.enable = true;
      nvim.enable = true;
      dotfiles.enable = true;
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
      latex.enable = false;
      nixlang.enable = true;
      flutter.enable = false;
    }
  ];
}
