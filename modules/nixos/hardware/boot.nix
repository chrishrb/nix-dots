{ config, pkgs, lib, ... }: {

  boot.loader = {
    grub = {
      enable = true;

      # Not sure what this does, but it involves the UEFI/BIOS
      efiSupport = true;

      # Check for other OSes and make them available
      useOSProber = true;

      # Limit the total number of configurations to rollback
      configurationLimit = 25;

      # Install GRUB onto the boot disk
      #device = config.fileSystems."/boot".device;

      # Don't install GRUB
      device = "nodev";
    };

    efi = {
      canTouchEfiVariables = true;
      efiSysMountPoint = "/boot/EFI";
    };

    systemd-boot.enable = false;
  };

  # Allow reading from Windows drives
  boot.supportedFilesystems = [ "ntfs" ];

  # Use latest released Linux kernel by default
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

}
