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
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:LnL7/nix-darwin/master";
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

    # chrisNvim
    chris-nvim.url = "github:chrishrb/nix-nvim";
  };

  outputs = { nixpkgs, ... } @inputs:
    let
      # Global configuration for my systems
      globals = rec {
        user = "chrisrb";
        fullName = "Christoph Herb";
        gitName = fullName;
        gitEmail = "52382992+chrishrb@users.noreply.github.com";
        gitWorkEmail = "christoph.herb@maibornwolff.de";
        dotfilesRepo = "https://github.com/chrishrb/nix-dots";
      };

      # Common overlays
      overlays = [
        inputs.alacritty-theme.overlays.default
      ];

      # System types to support.
      supportedSystems = [ "aarch64-darwin" "x86_64-linux" ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    in rec {

      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#ambush
      nixosConfigurations = {
        ambush = import ./hosts/ambush { inherit inputs globals overlays; };
      };

      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#mw
      darwinConfigurations = {
        mw = import ./hosts/mw { inherit inputs globals overlays; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#mw
      homeConfigurations = {
        ambush = nixosConfigurations.ambush.config.home-manager.users."christoph".home;
        mw = darwinConfigurations.mw.config.home-manager.users."christoph.herb".home;
      };

      # Programs that can be run by calling this flake
      #apps = forAllSystems (system:
      #  let pkgs = import nixpkgs { inherit system overlays; };
      #  in import ./apps { inherit pkgs; });

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
