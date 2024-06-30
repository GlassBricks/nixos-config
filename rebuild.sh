#!/usr/bin/env bash

# commit if there are changes
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit || exit 1
    git push || exit 1
fi

# if changes to nixos folder, run nixos-rebuild
if git diff --name-only HEAD~1 HEAD | grep -q nixos; then
    sudo nixos-rebuild switch || exit 1
fi

# run home-manager switch
home-manager --flake /etc/nixos switch || exit 1
