{ config, lib, pkgs, ... }: {

  imports =
    [ ./applications ./programming ./repositories ./shell ];

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
        default =
          if pkgs.stdenv.isDarwin then "$HOME/Downloads" else "$HOME/downloads";
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
        default = false;
      };
    };
    homePath = lib.mkOption {
      type = lib.types.path;
      description = "Path of user's home directory.";
      default = builtins.toPath (if pkgs.stdenv.isDarwin then
        "/Users/${config.user}"
      else
        "/home/${config.user}");
    };
    dotfilesPath = lib.mkOption {
      type = lib.types.path;
      description = "Path of dotfiles repository.";
      default = config.homePath + "/dev/home/nix-dots";
    };
    dotfilesRepo = lib.mkOption {
      type = lib.types.str;
      description = "Link to dotfiles repository HTTPS URL.";
    };
    unfreePackages = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      description = "List of unfree packages to allow.";
      default = [ ];
    };
  };

  config = let stateVersion = "23.11";
  in {

    # Basic common system packages for all devices
    environment.systemPackages = with pkgs; [ git vim wget curl ];

    # Use the system-level nixpkgs instead of Home Manager's
    home-manager.useGlobalPkgs = true;

    # Install packages to /etc/profiles instead of ~/.nix-profile, useful when
    # using multiple profiles for one user
    home-manager.useUserPackages = true;

    # Allow specified unfree packages (identified elsewhere)
    # Retrieves package object based on string name
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) config.unfreePackages;

    # Pin a state version to prevent warnings
    home-manager.users.${config.user}.home.stateVersion = stateVersion;
    home-manager.users.root.home.stateVersion = stateVersion;

  };

}
