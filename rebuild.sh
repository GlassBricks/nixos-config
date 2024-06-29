#!/usr/bin/env bash

# commit if there are changes; if user abort, then abort
if [ -n "$(git status --porcelain)" ]; then
    git add .
    git commit || exit 1
    git push || exit 1
fi

# pull in /etc/nixos
sudo git -C /etc/nixos pull || exit 1

# rebuild
sudo nixos-rebuild switch || exit 1
