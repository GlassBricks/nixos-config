{pkgs, ...}: {
  home.packages = [
    (pkgs.factorio.override {
      versionsJson = ./versions.json;
      experimental = true;
    })
  ];
}
