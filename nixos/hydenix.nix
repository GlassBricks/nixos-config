{inputs, pkgs, ...}: {
  imports = [
    inputs.hydenix.lib.nixOsModules
  ];
  nixpkgs.overlays = [
    inputs.hydenix.lib.overlays
  ];

  hydenix = {
    hardware.enable = true;
    system.enable = true;
    nix.enable = false;
    sddm.enable = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanager
    networkmanagerapplet
    networkmanager-openvpn
    kdePackages.kwallet
    kdePackages.kwallet-pam
    kdePackages.kwalletmanager
  ];
}
