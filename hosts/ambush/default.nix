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
        device = "/dev/disk/by-uuid/013e6f70-f179-47fd-af86-63d57a43ec68";
        fsType = "ext4";
      };

      # Turn on all features related to desktop and graphical apps
      gui.enable = true;

      # pw
      passwordHash = inputs.nixpkgs.lib.fileContents ../../misc/password.sha512;

      # Programs and services
      alacritty.enable = true;
      chrome.enable = true;
      chrisNvim.enable = true;
      nixlang.enable = true;
      python.enable = true;
      lua.enable = true;
      slack.enable = false;

      # specific for vbox
      #virtualisation.virtualbox.guest.enable = true;
    }
  ];
}
