{ config, pkgs, lib, ... }: {

  imports = [ ./timezone.nix ./user.nix ];

  config = lib.mkIf pkgs.stdenv.isLinux {

    # Pin a state version to prevent warnings
    system.stateVersion =
      config.home-manager.users.${config.user}.home.stateVersion;

  };

}
