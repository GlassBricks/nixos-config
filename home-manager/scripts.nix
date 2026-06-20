# Personal bash/stdlib scripts, symlinked into ~/bin (on PATH via home.sessionPath).
# mkOutOfStoreSymlink points at the live working-tree source, so edits take effect
# immediately -- no rebuild per tweak. Scripts needing third-party deps are packaged
# under pkgs/ instead (see scripts.md).
{ config, ... }:
let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  dir = "${config.home.homeDirectory}/nixos-config/scripts";
  scripts = [
    "krohnkite-on"
    "libresplit-reset-restart"
    "nix-autobahn-find-libs"
    "streamctl"
  ];
in {
  home.file = builtins.listToAttrs (map (name: {
    name = "bin/${name}";
    value.source = mkOutOfStoreSymlink "${dir}/${name}";
  }) scripts);
}
