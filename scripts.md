# Personal scripts

All source lives here in `~/nixos-config`; `~/.local/bin` is just a `$PATH` dir that
home-manager fills with symlinks. Two homes, split by whether a script needs
third-party deps.

## Layout & routing

- `scripts/<name>` -- bash and stdlib-only Python. Symlinked into `~/.local/bin` by
  `home-manager/scripts.nix` via `mkOutOfStoreSymlink`, so edits to the working-tree
  file are live (no rebuild). `#!/usr/bin/env bash` or `#!/usr/bin/env python3`.
- `pkgs/<name>/` -- anything needing third-party deps. Packaged with nix, installed via
  `home.packages`, deps isolated (pinned; not in the global env).

Decision rule: **a non-stdlib import -> `pkgs/`; otherwise `scripts/`.**

`~/.local/bin` holds no sources -- only home-manager-managed symlinks.

## Developing

- `scripts/<name>` -- edit the file; it's already live on `$PATH`. Run it directly.
- `pkgs/<name>/` (dep-using):
  - iterate: `nix develop .#<name>` then `python pkgs/<name>/<name>.py ...` (runs the
    live file, no rebuild). Headless: `nix develop .#<name> --command python pkgs/<name>/<name>.py ARGS`.
  - `my-nixos-rebuild` only to install/update the shipped wrapper or when deps change.

## Create a stdlib/bash script

1. Add the file at `scripts/<name>` (`chmod +x`).
2. Add `"<name>"` to the `scripts` list in `home-manager/scripts.nix`.
3. `git add scripts/<name>` and `my-nixos-rebuild` (creates the `~/.local/bin` symlink).

After that first rebuild, edits are live -- no further rebuild needed.

## Create a dep-using script

Worked example: `pkgs/pdf2md/`.

1. `pkgs/<name>/<name>.py` -- the script.
2. `pkgs/<name>/python-deps.nix` -- `ps: [ps.<dep>]` (shared by package + dev shell).
3. `pkgs/<name>/default.nix` -- `writeShellScriptBin` wrapping
   `python3.withPackages (import ./python-deps.nix)` (deps reachable only via the
   wrapper, never added to the global env).
4. Register in `pkgs/default.nix`: `<name> = pkgs.callPackage ./<name> {};`
5. Dev shell in `flake.nix`: add `devShells.<name>`.
6. Install: add `<name>` to `home.packages` (`home-manager/programs/default.nix`). The
   `additions` overlay only puts it in scope -- you still must list it here.
7. **`git add pkgs/<name>` before building.** Flakes copy only git-tracked files; an
   untracked new dir fails eval with `path ... does not exist`.
8. Test: `nix build .#<name>` then `nix develop .#<name>`. Ship: `my-nixos-rebuild`.

## Add a dep to an existing `scripts/` script

Migrate, don't pip/venv: move the source into `pkgs/<name>/`, follow the checklist
above, drop it from `scripts/` and `home-manager/scripts.nix`.

## KDE / KWin / D-Bus gotchas (hard-won)

Apply to scripts that drive the KDE session (e.g. `scripts/streamctl`).

- **The agent shell cannot reach the live session bus** (`/run/user/1000/bus` is
  namespaced away). KDE D-Bus / `qdbus` / `kwriteconfig6`-effect scripts can only be
  syntax/logic-checked by the agent -- the user must run and report.
- **A malformed D-Bus message to `org.kde.kglobalaccel` aborts the whole process.** On
  Wayland kglobalacceld runs inside KWin, so a bad signature crashes the session (lost
  work). Never guess a signature: verify against KDE source or `busctl introspect`.
  kglobalaccel marshals `QKeySequence` as a plain int -> keys go over the wire as `ai`,
  NOT `a(ai)`. See the `setShortcut`/`setForeignShortcut` comments in `streamctl`.
- **Never restart KDE/KWin/kglobalaccel to "reload" config** -- it terminates the
  session and everything in it, including the agent. Live config changes must go through
  the right D-Bus call (e.g. `setShortcut` with SetPresent), not a daemon restart.
- drkonqi backtraces fail on NixOS (`preamble.py` aborts on libs with no build-id, e.g.
  `libatomic.so.1`). Run gdb directly on the `/tmp/drkonqi-core.*` core instead.
