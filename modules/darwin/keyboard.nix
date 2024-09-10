{ inputs, pkgs, lib, ... }: {

  config = lib.mkIf pkgs.stdenv.isDarwin {

    system.activationScripts.keyboard.text = ''
      printf >&2 'setting up /Library/Keyboard Layouts...\n'

      ${pkgs.rsync}/bin/rsync \
        --archive \
        --copy-links \
        --delete-during \
        --delete-missing-args \
        "${inputs.macos-keyboard-layout-german-programming}/src/Deutsch - Programming.bundle" \
        '/Library/Keyboard Layouts/'
    '';
  };
}
