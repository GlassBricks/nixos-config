# pdf2md: PDF -> Markdown. A single-file Python script wrapped with an isolated,
# pinned python env -- the deps are reachable only by this wrapper, NOT added to
# the global env (so the user's `python3` can't import them).
# Fast iteration without rebuilding: `nix develop .#pdf2md`.
{
  writeShellScriptBin,
  python3,
}: let
  pyEnv = python3.withPackages (import ./python-deps.nix);
in
  writeShellScriptBin "pdf2md" ''
    exec ${pyEnv}/bin/python3 ${./pdf2md.py} "$@"
  ''
