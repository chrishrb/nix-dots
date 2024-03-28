# The ambush home config
# System configuration for my home pc

{ inputs, globals, overlays, ... }:

inputs.nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = { inherit inputs; };
  modules = [
    ../../modules/common
    ../../modules/nixos
    (globals // {
      user = "christoph";
    })
    inputs.home-manager.nixosModules.home-manager
    {
      nixpkgs.overlays = overlays;

      # Hardware
      networking.hostName = "ambush";

      boot.initrd.availableKernelModules = [ "ata_piix" "ohci_pci" "sd_mod" "sr_mod" ];

      # file systems
      fileSystems."/" = { 
        device = "/dev/disk/by-uuid/f06c56c1-4cd5-42ee-8586-eb52dcc622c6";
        fsType = "ext4";
      };
      swapDevices = [ { device = "/dev/disk/by-uuid/a7c9af8b-e4b7-4ef8-bda4-7177c3da7686"; } ];

      # Turn on all features related to desktop and graphical apps
      gui.enable = true;

      # pw
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;

      # Programs and services
      alacritty.enable = true;
      nixlang.enable = true;
      python.enable = true;
      lua.enable = true;
      slack.enable = false;

      # specific for vbox
      virtualisation.virtualbox.guest.enable = true;
    }
  ];
}
