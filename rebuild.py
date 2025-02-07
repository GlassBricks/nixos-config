#! /usr/bin/env cached-nix-shell
#! nix-shell -i python3 -p python3
import subprocess
import os
import sys
from subprocess import CalledProcessError


def run(cmd):
    subprocess.run(cmd, shell=True, check=True)


os.chdir("/home/ben/nixos-config")


def has_git_changes():
    return subprocess.run("git status --porcelain", shell=True, capture_output=True).stdout != b""

had_git_changes = has_git_changes()
print(had_git_changes)

run("git add .")
run("alejandra .")

made_commit = False

if has_git_changes():
    if not had_git_changes:
        run("git commit --amend --no-edit")
    else:
        run("git add .")
        run("git commit")
        made_commit = True

changed_files = subprocess.run("git diff --name-only HEAD^ HEAD", shell=True,
                               capture_output=True).stdout.decode().splitlines()

change_all_strs = [
    "flake.",
    "modules/",
    "overlays/",
    "pkgs/",
]

args = sys.argv[1:]

should_update_all = "-a" in args or any(
    f.startswith(s)
    for f in changed_files
    for s in change_all_strs
)

should_update_nixos = should_update_all or any(
    f.startswith("nixos/")
    for f in changed_files
)

should_update_home = should_update_all or any(
    f.startswith("home-manager/")
    for f in changed_files
)

print("update nixos:", should_update_nixos)
print("update home:", should_update_home)


try:
    if should_update_nixos:
        run("sudo nixos-rebuild --flake . switch")

    if should_update_home:
        run("home-manager --flake . switch")
except CalledProcessError:
    if made_commit:
        run("git reset HEAD^")
    raise

run("git push")
