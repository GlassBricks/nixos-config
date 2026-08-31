"""Shared helpers for the nixos-config rebuild scripts."""

import os
import subprocess

REPO = "/home/ben/nixos-config"
HM_ACTIVATION_PACKAGE = '.#homeConfigurations."ben@nixos".activationPackage'


def setup_env():
    os.chdir(REPO)
    # cached-nix-shell caches a TMPDIR pointing at a nix-shell temp dir that is
    # already gone, breaking nix builds and the home-manager activate step. Drop it
    # so child processes fall back to /tmp.
    for var in ("TMPDIR", "TMP", "TEMPDIR", "TEMP"):
        os.environ.pop(var, None)


def run(cmd):
    subprocess.run(cmd, shell=True, check=True)


def git_output(cmd):
    return subprocess.run(cmd, shell=True, capture_output=True).stdout.decode().strip()


def staged_files():
    out = git_output("git diff --cached --name-only")
    return out.splitlines() if out else []


def generate_commit_message():
    diff = git_output("git diff --cached")
    prompt = (
        "Write a concise one-line git commit message (imperative mood, ~70 chars "
        "max) for these staged changes. Output only the message, nothing else.\n\n"
        + diff
    )
    result = subprocess.run(
        ["claude", "-p", "--model", "sonnet", prompt],
        capture_output=True,
        text=True,
        check=True,
    )
    return result.stdout.strip()


def resolve_commit_message(message=None, generate=False, default=None):
    if message is not None:
        return message
    if generate:
        message = generate_commit_message()
        print("Generated:", message)
        return message
    if default is not None:
        return default
    message = input("Commit message ('a' = generate with claude, empty = editor): ").strip()
    if message.lower() == "a":
        message = generate_commit_message()
        print("Generated:", message)
    return message


def rebuild(update_nixos, update_home):
    # Prompt for sudo now so nixos-rebuild does not block mid-build.
    if update_nixos:
        run("sudo -v")

    # Pre-build the home-manager activation package so it can activate from a sealed
    # store path after nixos-rebuild has shifted the system out from under us.
    if update_home:
        run(f"nix build {HM_ACTIVATION_PACKAGE} -o hm-result")

    if update_nixos:
        run("sudo nixos-rebuild --flake . switch")

    if update_home:
        run("./hm-result/activate")


def commit_and_push(message, paths=()):
    cmd = ["git", "commit"]
    if message:
        cmd += ["-m", message]
    if paths:
        cmd += ["--", *paths]
    subprocess.run(cmd, check=True)
    run("git push")
