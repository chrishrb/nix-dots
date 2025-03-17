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
      networking.hostName = "mb-pro-cc";

      # Turn on all features related to desktop and graphical apps
      gui.enable = true;
      work.enable = true;

      # Programs and services
      colima.enable = true;
      alacritty.enable = true;
      chrisNvim.enable = true;
      dotfiles.enable = false;
      drawio.enable = false;
      chrome.enable = true;
      zoom.enable = true;

      # languaages
      php.enable = true;
      python.enable = true;
      lua.enable = true;
      devops.enable = true;
      go.enable = true;
      java.enable = false;
      web.enable = true;
      ai.enable = true;
      discord.enable = false;
      latex.enable = false;
      nixlang.enable = true;
    }
  ];
}
