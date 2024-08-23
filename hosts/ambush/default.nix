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

      boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];

      # file systems
      fileSystems."/" = {
        device = "/dev/disk/by-label/nixos";
        fsType = "ext4";
      };
      fileSystems."/boot" = {
        device = "/dev/disk/by-label/boot";
        fsType = "vfat";
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
