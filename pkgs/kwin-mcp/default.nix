{
  lib,
  python3Packages,
  fetchFromGitHub,
  gobject-introspection,
  wrapGAppsHook3,
  at-spi2-core,
  glib,
  libei,
  kdePackages,
  wl-clipboard,
  wtype,
  wayland-utils,
  makeWrapper,
}:
python3Packages.buildPythonApplication rec {
  pname = "kwin-mcp";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "isac322";
    repo = "kwin-mcp";
    rev = "v${version}";
    hash = "sha256-ITcnVAKEZNq/ssS1O6QiXRQNxUQQhuFpu3ENTpOcSY8=";
  };

  build-system = [python3Packages.uv-build];

  # - Relax build backend pin (upstream wants uv_build>=0.10.3, nixpkgs ships 0.9.7).
  # - Variadic ctypes call passes seat as Python int → ABI mismatch → segfault.
  #   Wrap in c_void_p so the 64-bit pointer is preserved.
  # - nixpkgs python wrappers inject deps via site.addsitedir, not PYTHONPATH.
  #   AT-SPI2 helper subprocess uses bare sys.executable → can't import kwin_mcp.
  #   Propagate sys.path as PYTHONPATH for the subprocess env.
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'uv_build>=0.10.3,<0.12.0' 'uv_build>=0.9.7,<0.12.0'
    substituteInPlace src/kwin_mcp/input.py \
      --replace-fail 'func(seat, *args)' 'func(ctypes.c_void_p(seat), *args)'
    substituteInPlace src/kwin_mcp/core.py \
      --replace-fail 'env = {**os.environ}' 'env = {**os.environ, "PYTHONPATH": os.pathsep.join(p for p in sys.path if p)}'
  '';

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
    makeWrapper
  ];

  buildInputs = [
    at-spi2-core
    glib
    libei
  ];

  dependencies = with python3Packages; [
    mcp
    pygobject3
    dbus-python
    pillow
  ];

  # Avoid double-wrapping; merge gappsWrapperArgs into the python wrappers.
  dontWrapGApps = true;

  runtimeDeps = [
    kdePackages.spectacle
    wl-clipboard
    wtype
    wayland-utils
  ];

  preFixup = ''
    makeWrapperArgs+=(
      "''${gappsWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath runtimeDeps}
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [libei]}
    )
  '';

  pythonImportsCheck = ["kwin_mcp"];

  meta = {
    description = "MCP server for KDE Plasma 6 Wayland desktop GUI automation";
    homepage = "https://github.com/isac322/kwin-mcp";
    license = lib.licenses.mit;
    mainProgram = "kwin-mcp";
    platforms = lib.platforms.linux;
  };
}
