# Hook home-manager to make a trampoline for each app we install
# from: https://github.com/nix-community/home-manager/issues/1341#issuecomment-1870352014
{
  config,
  lib,
  pkgs,
  ...
}:
with lib; {
  config = mkIf pkgs.stdenv.hostPlatform.isDarwin {
    # Install MacOS applications to the user Applications folder. Also update Docked applications
    home-manager.users.${config.user}.home = {

      extraActivationPath = with pkgs; [
        rsync
        dockutil
        gawk
      ];

      activation.trampolineApps = config.home-manager.users.${config.user}.lib.dag.entryAfter ["writeBoundary"] ''
        ${builtins.readFile ./lib-bash/trampoline-apps.sh}
        fromDir="$HOME/Applications/Home Manager Apps"
        toDir="$HOME/Applications/Home Manager Trampolines"
        sync_trampolines "$fromDir" "$toDir"
      '';
    };
  };
}
