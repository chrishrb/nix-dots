{
  config,
  pkgs,
  lib,
  ...
}:
{

  config = lib.mkIf (pkgs.stdenv.isLinux && config.gui.enable) {

    # Enable pipewire
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    hardware.pulseaudio.enable = false;

    security.rtkit.enable = true;

  };
}
