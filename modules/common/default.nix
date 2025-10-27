{
  inputs,
  config,
  lib,
  pkgs,
  ...
}:
{

  imports = [
    ./applications
    ./programming
    ./shell
  ];

  options = {
    user = lib.mkOption {
      type = lib.types.str;
      description = "Primary user of the system";
    };
    fullName = lib.mkOption {
      type = lib.types.str;
      description = "Human readable name of the user";
    };
    userDirs = {
      # Required to prevent infinite recursion when referenced by himalaya
      download = lib.mkOption {
        type = lib.types.str;
        description = "XDG directory for downloads";
        default = if pkgs.stdenv.isDarwin then "$HOME/Downloads" else "$HOME/downloads";
      };
      screenshots = lib.mkOption {
        type = lib.types.str;
        description = "Directory for screenshots";
        default = "$HOME/screenshots";
      };
    };
    gui = {
      enable = lib.mkEnableOption {
        description = "Enable graphics.";
      };
    };
    work = {
      enable = lib.mkEnableOption {
        description = "Enable work specific options.";
      };
    };
    homePath = lib.mkOption {
      type = lib.types.path;
      description = "Path of user's home directory.";
      default = builtins.toPath (
        if pkgs.stdenv.isDarwin then "/Users/${config.user}" else "/home/${config.user}"
      );
    };
    sshKeyPath = lib.mkOption {
      type = lib.types.path;
      description = "Path of ssh private key.";
      default = config.homePath + "/.ssh/id_ed25519";
    };
    allowUnfree = lib.mkOption {
      type = lib.types.bool;
      description = "Allow to use unfree packages.";
      default = true;
    };
    theme = lib.mkOption {
      description = "Catppuccin theme to use for the system.";
      type = lib.types.enum [
        "latte"
        "frappe"
        "macchiato"
        "mocha"
      ];
      default = "mocha";
    };
    ai = {
      enable = lib.mkEnableOption {
        description = "Enable AI features.";
      };
      provider = lib.mkOption {
        description = "AI provider to use, e.g. copilot, ollama, etc.";
        default = "copilot";
        type = lib.types.enum [
          "ollama"
          "copilot"
          "gemini"
        ];
      };
      model = lib.mkOption {
        description = "AI model to use, e.g. gpt-5, gpt-4.1, claude-sonnet-4, etc.";
        default = "claude-sonnet-4";
        # Premium requests required
        # https://docs.github.com/en/copilot/concepts/billing/copilot-requests
        # default = "claude-sonnet-4";
        type = lib.types.str;
      };
    };
  };

  config =
    let
      stateVersion = "23.11";
    in
    {

      # Basic common system packages for all devices
      environment.systemPackages = with pkgs; [
        git
        vim
        wget
        curl
      ];

      # Use the system-level nixpkgs instead of Home Manager's
      home-manager.useGlobalPkgs = true;

      # Install packages to /etc/profiles instead of ~/.nix-profile, useful when
      # using multiple profiles for one user
      home-manager.useUserPackages = true;

      # Allow unfree packages
      nixpkgs.config.allowUnfree = config.allowUnfree;

      # Pin a state version to prevent warnings
      home-manager.users.${config.user}.home.stateVersion = stateVersion;
      home-manager.users.root.home.stateVersion = stateVersion;

      # activate agenix
      home-manager.sharedModules = [
        inputs.agenix.homeManagerModules.default
      ];

    };
}
