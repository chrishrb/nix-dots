{ config, pkgs, lib, inputs, ... }: {

  # Homebrew - Mac-specific packages that aren't in Nix
  config = lib.mkIf pkgs.stdenv.isDarwin {

    nix-homebrew = {
      enable = true;
      user = config.user;
      taps = {
        "homebrew/homebrew-core" = inputs.homebrew-core;
        "homebrew/homebrew-cask" = inputs.homebrew-cask;
        "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
      };
      mutableTaps = false;
      autoMigrate = true;
    };

    homebrew = {
      enable = true;
      taps = builtins.attrNames config.nix-homebrew.taps;
      onActivation = {
        autoUpdate = false; # Don't update during rebuild
        cleanup = "zap"; # Uninstall all programs not declared
        upgrade = true;
      };
      brews = [
        #"grip" # open readme files
      ];
      casks = [
        # Communication Tools
        "notion"

        # utility
        "scroll-reverser"
        "tiles"
        "skim" # open pdfs

        # other
        "bitwarden"
        "spotify"
        "logi-options+"
        "keepassxc"
        "notunes" # disable autolaunch of music app

      ] ++ lib.optionals config.work.enable [

        "tunnelblick"
        "microsoft-teams"
      ];
    };

    # These app IDs are from using the mas CLI app
    # mas = mac app store
    # https://github.com/mas-cli/mas
    #
    # $ nix shell nixpkgs#mas
    # $ mas search <app name>
    #
    # masApps = {
    # };
  };

}
