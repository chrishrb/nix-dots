{ ... }:
{

  imports = [
    ./boot.nix
    ./audio.nix
    ./keyboard.nix
    ./wifi.nix
  ];

  hardware.enableAllFirmware = true;
}
