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
      device = config.fileSystems."/boot".device;
    };

    systemd-boot.enable = true;
  };

  # Allows GRUB to interact with the UEFI/BIOS I guess
  efi.canTouchEfiVariables = true;

  # Allow reading from Windows drives
  boot.supportedFilesystems = [ "ntfs" ];

  # Use latest released Linux kernel by default
  boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_latest;

}
