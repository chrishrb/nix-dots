{
  pkgs,
  lib,
  inputs,
  ...
}:
{

  # Fix trampoline apps on macOS
  config = lib.mkIf pkgs.stdenv.isDarwin {
    # To enable it for all users:
    home-manager.sharedModules = [
      inputs.mac-app-util.homeManagerModules.default
    ];

  };
}
