#!/usr/bin/env bash

# cd to the directory of the script
cd "/home/ben/nixos-config/" || exit 1

# commit if there are changes
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit || exit 1
    git push || exit 1
fi

# if changes to nixos folder, run nixos-rebuild
if git diff --name-only HEAD~1 HEAD | grep -q nixos; then
    sudo nixos-rebuild --flake . switch || exit 1
fi

# if changes to home-manager folder, run home-manager switch
if git diff --name-only HEAD~1 HEAD | grep -q home-manager; then
    home-manager switch --flake . || exit 1
fi
