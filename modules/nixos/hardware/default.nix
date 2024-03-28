{ lib, ... }: {

  imports = [
    ./keyboard.nix
    ./wifi.nix
  ];

  options = {
    physical = lib.mkEnableOption "Whether this machine is a physical device.";
    server = lib.mkEnableOption "Whether this machine is a server.";
  };

}
