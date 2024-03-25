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
        "tofuutils/homebrew-taps" = inputs.tofuutils;
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
        "trash" # Delete files and folders to trash instead of rm
        "tofuutils/taps/tenv" # terraform, opentofu, terragrunt version manager
        "grip" # open readme files
      ];
      casks = [
        # Development Tools
        "homebrew/cask/docker"

        # latex
        # "mactex-no-gui"

        # Communication Tools
        "notion"
        "zoom"

        # utility
        "scroll-reverser"
        "tiles"
        "skim" # open pdfs

        # Browsers
        "google-chrome"

        # other
        "bitwarden"
        "spotify"
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
