{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  homeDirectory = config.home.homeDirectory;
  relativePathApply = p:
    if hasPrefix "/" p
    then p
    else "${homeDirectory}/${p}";
  # checkName = name: name;
  #    if (builtins.match "^[a-zA-Z0-9_-]+$" name) == null
  #    then abort "Name must be all alphanumeric, - or _"
  #    else name;

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
        description = "Common directory for saves, mods, baseConfig, etc.";
        type = types.str;
        apply = relativePathApply;
        default = ".factorio";
      };
      linkCommon = mkOption {
        description = "List of files/directories to link from the common directory";
        type = types.listOf types.str;
        default = ["mods"];
      };
      links = mkOption {
        description = "key/value pairs of files to link";
        type = types.attrsOf types.str;
        default = {};
      };
      copyBaseConfigFromCommon = mkOption {
        type = types.bool;
        default = true;
      };
      executableName = mkOption {
        type = types.nullOr types.str;
        default = null;
      };
    };
  });
  optimizationWrapper = pkgs.writeScript "factorio-optimization-wrapper" ''
    #!${pkgs.stdenv.shell}
    FACTORIO_BINARY=$1
    shift

    export MIMALLOC_ALLOW_LARGE_OS_PAGES=1
    export MIMALLOC_RESERVE_HUGE_OS_PAGES=0
    export MIMALLOC_EAGER_COMMIT_DELAY=4
    export MIMALLOC_SHOW_STATS=0
    export MALLOC_ARENA_MAX=1
    export LD_PRELOAD="$LD_PRELOAD ${pkgs.mimalloc}/lib/libmimalloc.so"

    exec $FACTORIO_BINARY "$@"
  '';
  launcherScript = pkgs.writeScript "factorio-launcher" ''
    #!${pkgs.stdenv.shell}
    FACTORIO_PATH=$1
    WRITE_PATH=$2
    shift 2

    CONFIG_FILE="$WRITE_PATH/config/config.ini"
    # if config file exists, sed it to use the correct paths
    if [ -f $CONFIG_FILE ]; then
      sed -i "s|^write-data=.*|write-data=$WRITE_PATH|" $CONFIG_FILE
    fi

    exec ${optimizationWrapper} "$FACTORIO_PATH/bin/x64/factorio" -c "$CONFIG_FILE" "$@"
  '';
  configTemplate = ''
    [path]
    read-data=__PATH__executable__/../../data
    write-data=TOBEFILLED
  '';
  createFactorioDir = dataDir: installDir: baseConfigCopyPath: ''
    run mkdir -p "${dataDir}"
    # Create config/config.cfg if it doesn't exist
    run mkdir -p "${dataDir}/config"
    if [ ! -f "${dataDir}/config/config.ini" ]; then
      if [ -f "${baseConfigCopyPath}" ]; then
        run cp "${baseConfigCopyPath}" "${dataDir}/config/config.ini"
      else
        if [[ -v DRY_RUN ]]; then
          echo "Writing default config.ini to ${dataDir}/config/config.ini"
        else
          cat <<EOF > "${dataDir}/config/config.ini"
    ${configTemplate}
    EOF
        fi
      fi
    fi
    # sed read-data and write-data to the correct paths
    run sed -i 's|^write-data=.*|write-data=${dataDir}|' "${dataDir}/config/config.ini"
  '';
  cfgInstances = filterAttrs (name: v: v.enable) config.custom.factorio-install.instances;
  mkOutOfStoreLink = config.lib.file.mkOutOfStoreSymlink;
in {
  options = {
    custom.factorio-install = mkOption {
      description = "Custom factorio installation";
      default = {};
      type = types.submodule {
        options = {
          instances = mkOption {
            description = "Factorio installation instances";
            type = types.attrsOf installConfigType;
          };
        };
      };
    };
  };
  config = {
    # for each install config, create a directory for it
    home.activation.generateFactorioDataDirs = hm.dag.entryAfter ["writeBoundary"] (
      concatStrings (
        mapAttrsToList (name: v: let
          baseConfigCopyPath =
            if v.copyBaseConfigFromCommon
            then "${v.commonDir}/config/config.ini"
            else "";
        in (
          createFactorioDir v.dataDir v.installDir baseConfigCopyPath
        ))
        cfgInstances
      )
    );
    home.file =
      attrsets.concatMapAttrs (
        name: v: let
          inherit (v) dataDir commonDir linkCommon links;
        in
          # make a home.files.factorio-custom-${name}-${dirname} for each linkCommon
          (attrsets.mergeAttrsList (map (
              dirname: {
                "factorio-custom-${name}-common-${dirname}" = {
                  source = mkOutOfStoreLink "${commonDir}/${dirname}";
                  target = "${dataDir}/${dirname}";
                };
              }
            )
            linkCommon))
          //
          # make a home.files.factorio-custom-${name}-${linkName} for each link
          attrsets.concatMapAttrs (
            target: source: {
              "factorio-custom-${name}-link-${target}" = {
                source = mkOutOfStoreLink (relativePathApply source);
                target = "${dataDir}/${target}";
              };
            }
          )
          links
      )
      cfgInstances;
    # make custom desktop entries
    xdg.desktopEntries =
      attrsets.concatMapAttrs (
        name: v: let
          inherit (v) dataDir installDir displayName;
        in {
          "factorio-${name}" = {
            name = "Factorio ${displayName}";
            exec = "${launcherScript} \"${installDir}\" \"${dataDir}\" %F";
            icon = "${installDir}/data/core/graphics/factorio-icon.png";
            terminal = false;
            categories = ["Game"];
            type = "Application";
          };
        }
      )
      cfgInstances;
    home.packages =
      attrsets.mapAttrsToList (
        k: v: pkgs.writeScriptBin v.executableName ''exec ${launcherScript} "${v.installDir}" "${v.dataDir}" "$@"''
      )
      (attrsets.filterAttrs (k: v: v.executableName != null) cfgInstances);
    home.sessionVariables = {
      FACTORIO_WRAPPER = "${optimizationWrapper}";
    };
  };
}
