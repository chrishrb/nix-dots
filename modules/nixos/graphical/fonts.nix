{ config, pkgs, lib, ... }: {

  config = lib.mkIf (config.gui.enable && pkgs.stdenv.isLinux) {

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

}
