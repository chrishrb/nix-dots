{
  description = "chrishrb's nix-dots";

  inputs = {
    # system packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };

    # macOS system config
    darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # homebrew
    nix-homebrew = {
      url = "github:zhaofengli-wip/nix-homebrew";
    };
    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    }; 
    tofuutils = {
      url = "github:tofuutils/homebrew-tap";
      flake = false;
    }; 

    # alacritty theme
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";
  };

  outputs = { nixpkgs, ... } @inputs:
    let
      # Global configuration for my systems
      globals = let baseName = "chrishrb";
      in rec {
        user = "chrisrb";
        fullName = "Christoph Herb";
        gitName = fullName;
        gitEmail = "52382992+chrishrb@users.noreply.github.com";
        dotfilesRepo = "https://github.com/chrishrb/nix-dots";
      };

      # Common overlays
      overlays = [
        inputs.alacritty-theme.overlays.default
      ];

      # System types to support.
      supportedSystems =
        [ "aarch64-darwin" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    in rec {
      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#laptop0997
      darwinConfigurations = {
        laptop0997 = import ./hosts/laptop0997 { inherit inputs globals overlays forAllSystems; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#laptop0997
      homeConfigurations = {
        laptop0997 = darwinConfigurations.laptop0997.config.home-manager.users."cherb".home;
      };

      # Programs that can be run by calling this flake
      apps = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in import ./apps { inherit pkgs; });

      # Development environments
      devShells = forAllSystems (system:
        let pkgs = import nixpkgs { inherit system overlays; };
        in {

          # Used to run commands and edit files in this repo
          default = pkgs.mkShell {
            buildInputs = with pkgs; [ git stylua nixfmt shfmt shellcheck ];
          };

        });

    };
}
