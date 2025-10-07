{
  description = "chrishrb's nix-dots";

  inputs = {
    # system packages
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

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

    # alacritty theme
    alacritty-theme.url = "github:alexghr/alacritty-theme.nix";

    # mac-app-util for fixing trampoline apps on mac
    mac-app-util.url = "github:hraban/mac-app-util";

    # talhelper
    talhelper.url = "github:budimanjojo/talhelper";

    # nvim
    nixCats.url = "github:BirdeeHub/nixCats-nvim/v7.2.13";

    # formatter
    treefmt-nix.url = "github:numtide/treefmt-nix";

    # ai tools
    mcp-hub.url = "github:ravitemer/mcp-hub";
    mcphub-nvim.url = "github:ravitemer/mcphub.nvim";
    mods = {
      url = "github:chrishrb/mods";
      flake = false;
    };

    # nvim plugins that are not in nixpkg
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
    codecompanion-history-nvim = {
      url = "github:ravitemer/codecompanion-history.nvim";
      flake = false;
    };
    none-ls-extras-nvim = {
      url = "github:nvimtools/none-ls-extras.nvim";
      flake = false;
    };
    nvim-tree-lua = {
      url = "github:nvim-tree/nvim-tree.lua";
      flake = false;
    };
    garbage-day-nvim = {
      url = "github:Zeioth/garbage-day.nvim";
      flake = false;
    };

    # keyboard layout
    macos-keyboard-layout-german-programming = {
      url = "github:MickL/macos-keyboard-layout-german-programming";
      flake = false;
    };

    # agenix for secrets management
    agenix.url = "github:ryantm/agenix";

    # Dependency for MCP
    powertools-lambda-python = {
      url = "github:aws-powertools/powertools-lambda-python";
      flake = false;
    };

    # MCP servers
    modelcontextprotocol-servers = {
      url = "github:modelcontextprotocol/servers";
      flake = false;
    };
    mcp-miro = {
      url = "github:k-jarzyna/mcp-miro";
      flake = false;
    };
    awslabs-mcp = {
      url = "github:awslabs/mcp";
      flake = false;
    };
    apple-mcp = {
      url = "github:supermemoryai/apple-mcp";
      flake = false;
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      ...
    }@inputs:
    let
      # Global configuration for my systems
      globals = rec {
        user = "chrisrb";
        fullName = "Christoph Herb";
        gitName = fullName;
        gitEmail = "52382992+chrishrb@users.noreply.github.com";
        gitWorkEmail = gitEmail;
      };

      # Common overlays
      overlays = [
        inputs.alacritty-theme.overlays.default
        (import ./overlays inputs)
      ];

      # System types to support.
      supportedSystems = [
        "aarch64-darwin"
        "x86_64-linux"
      ];

      # Helper function to generate an attrset '{ x86_64-linux = f "x86_64-linux"; ... }'.
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;

      # formatting
      treefmtEval = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system overlays; };
        in
        treefmt-nix.lib.evalModule pkgs ./treefmt.nix
      );
    in
    rec {

      # Contains my full system builds, including home-manager
      # nixos-rebuild switch --flake .#tuxedo
      nixosConfigurations = {
        tuxedo = import ./hosts/tuxedo { inherit inputs globals overlays; };
      };

      # Contains my full Mac system builds, including home-manager
      # darwin-rebuild switch --flake .#cc
      darwinConfigurations = {
        macbook-gipedo = import ./hosts/macbook-gipedo { inherit inputs globals overlays; };
        macbook-christoph = import ./hosts/macbook-christoph { inherit inputs globals overlays; };
      };

      # For quickly applying home-manager settings with:
      # home-manager switch --flake .#cc
      homeConfigurations = {
        tuxedo = nixosConfigurations.tuxedo.config.home-manager.users."christoph".home;
        macbook-gipedo = darwinConfigurations.macbook-gipedo.config.home-manager.users."christophherb".home;
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
              treefmt
              shfmt
              shellcheck
              mkpasswd
              inputs.agenix.packages.${system}.default
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
          nvim =
            pkgs.runCommand "neovim-check-health" { buildInputs = [ module.packages.${system}.default ]; }
              ''
                mkdir -p $out
                export HOME=$TMPDIR
                nvim --headless -c "checkhealth" -c "write $out/health.log" -c "quitall"

                # Check for errors inside the health log
                if $(grep "ERROR" $out/health.log); then
                  cat $out/health.log
                  exit 1
                fi
              '';

          formatting = treefmtEval.${system}.config.build.check self;
        }
      );

      formatter = forAllSystems (system: treefmtEval.${system}.config.build.wrapper);

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
