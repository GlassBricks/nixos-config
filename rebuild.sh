#!/usr/bin/env bash

# cd to the directory of the script
cd "/home/ben/nixos-config/" || exit 1

# run alejandra
alejandra . || exit 1

# commit if there are changes
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit || exit 1
fi
git push || exit 1

# shouldUpdateAll = (-a in args) or (flake.nix changed)
shouldUpdateAll=false
if [ "$1" == "-a" ] || git diff --name-only HEAD^ HEAD | grep -q "^(flake\.nix|flake\.lock|modules|overlays|pkgs)"; then
    shouldUpdateAll=true
fi

# shouldUpdateNixos = shouldUpdateAll or (nixos folder changed)
shouldUpdateNixos=false
if $shouldUpdateAll || git diff --name-only HEAD^ HEAD | grep -q "^nixos"; then
    shouldUpdateNixos=true
fi

shouldUpdateHomeManager=false
if $shouldUpdateNixos || git diff --name-only HEAD^ HEAD | grep -q "^home-manager"; then
    shouldUpdateHomeManager=true
fi

echo shouldUpdateAll: $shouldUpdateAll
echo shouldUpdateNixos: $shouldUpdateNixos
echo shouldUpdateHomeManager: $shouldUpdateHomeManager

if $shouldUpdateNixos; then
    sudo nixos-rebuild --flake . switch || exit 1
fi

if $shouldUpdateHomeManager; then
    home-manager switch --flake . || exit 1
fi
