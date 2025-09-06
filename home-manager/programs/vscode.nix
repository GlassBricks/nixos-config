{pkgs, lib, ...}: {
  programs.vscode = {
    enable = true;
    package = lib.mkForce pkgs.unstable.vscode.fhs;
  };
}
