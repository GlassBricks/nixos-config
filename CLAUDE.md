# CLAUDE.md

## Overview

Personal NixOS + Home Manager flake configuration for a single host (`nixos`) and user (`ben`). Uses stable with an unstable overlay for select packages.

## Build & Deploy

- **Format**: `alejandra .`
- **NixOS rebuild**: `sudo nixos-rebuild --flake . switch`
- **Home Manager rebuild**: `home-manager --flake . switch`
- **Check flake**: `nix flake check`
- **Update inputs**: `nix flake update`

Ad-hoc tooling is fine: `nix-shell -p <pkg>` or `, <cmd>` (comma) to run a one-off tool (e.g. debugging utilities) without adding it to the config.

## Architecture

```
flake.nix              # Single flake entrypoint; one nixosConfiguration "nixos", one homeConfiguration "ben@nixos"
├── nixos/
│   ├── configuration.nix    # System-level config (boot, networking, services, system packages, nix-ld libraries)
│   └── hardware-configuration.nix
├── home-manager/
│   ├── home.nix             # Home Manager entrypoint; imports fonts, shell, scripts, programs
│   ├── shell.nix            # Fish (primary shell, launched from bash), starship, kitty, tmux, zoxide, carapace
│   ├── scripts.nix          # Symlinks scripts/ into ~/.local/bin (live, via mkOutOfStoreSymlink)
│   ├── fonts.nix
│   └── programs/
│       ├── default.nix      # User packages (dev tools, GUI apps, games) and custom module configs
│       ├── git.nix
│       ├── spicetify.nix
│       ├── vscode.nix       # Currently disabled
│       └── custom-factorio.nix
├── overlays/default.nix     # Three overlays: additions (custom pkgs), modifications, unstable-packages
├── pkgs/                    # Custom package derivations (accessible as overlays via `additions`)
├── scripts/                 # Personal bash/stdlib scripts -> ~/.local/bin (see scripts.md); incl. my-nixos-rebuild (build/deploy)
├── scripts.md               # Where personal scripts live + how to develop them
└── modules/                 # Reusable NixOS and Home Manager modules
```

## Key Patterns

- **Shell**: Fish is the interactive shell, launched automatically from bash. Aliases and integrations are configured for both.
- **Custom packages**: live in `pkgs/`, registered in `pkgs/default.nix`, reach `home.packages`/system via the `additions` overlay.
- **Personal scripts**: bash/stdlib in `scripts/` (symlinked to `~/bin` by `home-manager/scripts.nix`), dep-using ones in `pkgs/<name>/`. Routing, dev/iteration workflow, new-script checklist, and KDE/KWin/D-Bus gotchas: read `scripts.md` before creating or editing any script.
