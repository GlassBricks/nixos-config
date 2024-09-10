{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  homeDirectory = config.home.homeDirectory;
  relativePathApply = p: let
    absPath =
      if hasPrefix "/" p
      then p
      else "${homeDirectory}/${p}";
  in
    absPath;
  installConfigType = types.submodule ({name, ...}: {
    options = {
      enable = mkOption {
        type = types.bool;
        default = true;
      };
      displayName = mkOption {
        description = "Display name";
        type = types.str;
        default = name;
      };
      dataDir = mkOption {
        description = "Data directory (relative to home directory)";
        type = types.str;
        apply = relativePathApply;
        default = ".factorio/instances/${name}";
      };
      installDir = mkOption {
        description = "Factorio installation directory (relative to home directory). Note, not the same as install package";
        type = types.str;
        apply = relativePathApply;
        default = "opt/factorio";
      };
      commonDir = mkOption {
        description = "Common directory for saves, mods, etc.";
        type = types.str;
        apply = relativePathApply;
        default = ".factorio";
      };
      linkCommon = mkOption {
        description = "List of files/directories to link from the common directory";
        type = types.listOf types.str;
        default = ["mods" "saves" "scenarios"];
      };
    };
  });
  #  configTemplate = dataDir: installDir: "[path]\\nwrite-data=${dataDir}\\n";
  configTemplate = dataDir: installDir: ''
    [path]
    write-data=${dataDir}'';
  createFactorioDir = dataDir: installDir: ''
    run mkdir -p ${dataDir}
    # Create config/config.cfg if it doesn't exist
    run mkdir -p ${dataDir}/config
    if [ ! -f ${dataDir}/config/config.ini ]; then
      if [[ -v DRY_RUN ]]; then
        echo "Writing default config.ini to ${dataDir}/config/config.ini"
      else
        cat <<EOF > ${dataDir}/config/config.ini
    ${configTemplate dataDir installDir}
    EOF
      fi
    fi
  '';
  cfg = config.custom.factorio-install;
in {
  options = {
    custom.factorio-install = mkOption {
      description = "Custom factorio installation";
      default = {};
      type = types.attrsOf installConfigType;
    };
  };
  config = {
    # for each install config, create a directory for it
    home.activation.generateFactorioDataDirs = hm.dag.entryAfter ["writeBoundary"] (
      concatStrings (
        mapAttrsToList (
          name: v: (createFactorioDir v.dataDir v.installDir)
        )
        cfg
      )
    );
    # make a home.files.factorio-custom-${name}-${dirname} for each linkCommon
    home.file =
      attrsets.concatMapAttrs (
        name: v: let
          inherit (v) dataDir installDir commonDir linkCommon;
        in
          attrsets.mergeAttrsList (map (
              dirname: {
                "factorio-custom-${name}-${dirname}" = {
                  source = "${commonDir}/${dirname}";
                  target = "${dataDir}/${dirname}";
                };
              }
            )
            linkCommon)
      )
      cfg;
  };
}
