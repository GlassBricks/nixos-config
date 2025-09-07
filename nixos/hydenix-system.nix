{
  inputs,
  pkgs,
  ...
}: {
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
    audio.enable = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanager
    networkmanagerapplet
    networkmanager-openvpn
  ];

  services.gnome.gnome-keyring.enable = true;
}
