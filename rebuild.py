#! /usr/bin/env cached-nix-shell
#! nix-shell -i python3 -p python3
import subprocess
import sys
import os
from subprocess import CalledProcessError

os.chdir("/home/ben/nixos-config")


def run(cmd):
    subprocess.run(cmd, shell=True, check=True)


def git_output(cmd):
    return subprocess.run(cmd, shell=True, capture_output=True).stdout.decode().strip()


def has_staged_changes():
    return git_output("git diff --cached --name-only") != ""


run("git add .")
run("alejandra .")
run("git add .")

if not has_staged_changes():
    print("No changes to commit.")
    sys.exit(0)

run("git commit")

changed_files = git_output("git diff --name-only HEAD^ HEAD").splitlines()

change_all_strs = ["flake.", "modules/", "overlays/", "pkgs/"]
args = sys.argv[1:]

should_update_all = "-a" in args or any(
    f.startswith(s) for f in changed_files for s in change_all_strs
)
should_update_nixos = should_update_all or any(f.startswith("nixos/") for f in changed_files)
should_update_home = should_update_all or any(f.startswith("home-manager/") for f in changed_files)

print("update nixos:", should_update_nixos)
print("update home:", should_update_home)

try:
    if should_update_nixos:
        run("sudo nixos-rebuild --flake . switch")
    if should_update_home:
        run("home-manager --flake . switch")
except CalledProcessError:
    run("git reset --soft HEAD^")
    raise

run("git push")
