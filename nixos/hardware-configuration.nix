# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{
  config,
  lib,
  pkgs,
  modulesPath,
  inputs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    inputs.nixos-hardware.nixosModules.msi-b550-a-pro
    inputs.nixos-hardware.nixosModules.common-gpu-amd-sea-islands
  ];

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/8e16d838-dbff-4555-baca-51cd50c06665";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/126E-AF0F";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
  };

  fileSystems."/bigdrive" = {
    device = "/dev/disk/by-uuid/7e423849-a6d5-4ed5-857d-e4871b47e5f5";
    fsType = "ext4";
  };
  zramSwap = {
    enable = true;
    priority = 5;
  };
  swapDevices = [
    {
      device = "/var/swapfile";
      size = 8 * 1024;
      priority = 4;
    }
    {
      device = "/dev/disk/by-uuid/b802824a-e17a-45ff-8362-c6501f56bce4";
      priority = 3;
    }
  ];
  boot.kernel.sysctl."vm.swappiness" = 10;

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp4s0.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
