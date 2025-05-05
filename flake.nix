{
  description = "chrishrb's nix-dots";

  inputs = {
    # system packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

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
      url = "github:zhaofengli/nix-homebrew";
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
    homebrew-mqttx = {
      url = "github:emqx/homebrew-mqttx";
      flake = false;
    };

    # alacritty theme
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";

    # mac-app-util for fixing trampoline apps on mac
    mac-app-util.url = "github:hraban/mac-app-util";

    # talhelper
    talhelper.url = "github:budimanjojo/talhelper";

    # chrisNvim
    nixCats.url = "github:BirdeeHub/nixCats-nvim/v7.2.13";

    # plugins that are not in nixpkg
    nvim-tmux-navigation = {
      url = "github:alexghergh/nvim-tmux-navigation";
      flake = false;
    };
    nvim-nio = {
      url = "github:nvim-neotest/nvim-nio";
      flake = false;
    };
    codecompanion-nvim = {
      url = "github:olimorris/codecompanion.nvim";
      flake = false;
    };
    none-ls-extras-nvim = {
      url = "github:nvimtools/none-ls-extras.nvim";
      flake = false;
    };

    # keyboard layout
    macos-keyboard-layout-german-programming = {
      url = "github:MickL/macos-keyboard-layout-german-programming";
      flake = false;
    };

    # cli tool for automatically creating commit messages
    ai-commit = {
      url = "github:chrishrb/ai-commit";
    };
    go-grip = {
      url = "github:chrishrb/go-grip";
    };
  };

  outputs =
    { nixpkgs, ... }@inputs:
    let
      # Global configuration for my systems
      globals = rec {
        user = "chrisrb";
        fullName = "Christoph Herb";
        gitName = fullName;
        gitEmail = "52382992+chrishrb@users.noreply.github.com";
        gitWorkEmail = "c.herb@chargecloud.de";
        dotfilesRepo = "git@github.com:chrishrb/nix-dots.git";
      };

      # Common overlays
      overlays = [
        inputs.alacritty-theme.overlays.default
        (import ./overlays/stable.nix inputs)
        (import ./overlays/talhelper.nix inputs)
        (import ./overlays/personal.nix inputs)
        (import ./overlays/catppuccin.nix inputs)
      ];

      # System types to support.
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

    in
    rec {

      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#ambush
      # nixosConfigurations = {
      #   ambush = import ./hosts/ambush { inherit inputs globals overlays; };
      # };

      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#cc
      darwinConfigurations = {
        mb-pro-cc = import ./hosts/mb-pro-cc { inherit inputs globals overlays; };
        macbook-christoph = import ./hosts/macbook-christoph { inherit inputs globals overlays; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#cc
      homeConfigurations = {
        # ambush = nixosConfigurations.ambush.config.home-manager.users."christoph".home;
        mb-pro-cc = darwinConfigurations.mb-pro-cc.config.home-manager.users."christophherb".home;
        macbook-christoph = darwinConfigurations.cc.config.home-manager.users."christophherb".home;
      };

      # Programs that can be run by calling this flake
      apps = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        import ./apps { inherit system inputs pkgs; }
      );

      # Development environments
      devShells = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        {

          # Used to run commands and edit files in this repo
          default = pkgs.mkShell {
            buildInputs = with pkgs; [
              git
              stylua
              nixfmt-rfc-style
              shfmt
              shellcheck
            ];
          };

        }
      );

      # Checks for nvim health
      checks = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
          module = import ./modules/common/nvim { inherit inputs; };
        in
        {
          chrisNvim =
            pkgs.runCommand "neovim-check-health" { buildInputs = [ module.packages.${system}.default ]; }
              ''
                mkdir -p $out
                export HOME=$TMPDIR
                chrisNvim -c "checkhealth" -c "write $out/health.log" -c "quitall"

                # Check for errors inside the health log
                if $(grep "ERROR" $out/health.log); then
                  cat $out/health.log
                  exit 1
                fi
              '';
        }
      );

      # Templates for starting other projects quickly
      templates = rec {
        default = basic;
        basic = {
          path = ./templates/basic;
          description = "Basic program template";
        };
        python = {
          path = ./templates/python;
          description = "Python template";
        };
      };

    };
}
