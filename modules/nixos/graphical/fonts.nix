{ config, pkgs, lib, ... }: {

  config = lib.mkIf (config.gui.enable && pkgs.stdenv.isLinux) {

    fonts.packages = with pkgs; [
      (nerdfonts.override { fonts = ["JetBrainsMono"]; })
    ];
  };

}
