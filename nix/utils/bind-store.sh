#!/bin/bash

################################################################################
# Nix Store Bind Mount Script
#
# Purpose:
#   Makes /nix a bind mount of a directory that survives a rebuild of the root
#   filesystem.
#   Use it on a host that has a disposable root disk and a persistent home
#   disk, for example a cloud VM that boots from a fresh image each time.
#
# Behavior:
#   1. Runs itself again with sudo, if it does not have root permission
#   2. Creates the backing directory and /nix, if they do not exist
#   3. Moves an existing store into the backing directory, if --migrate is set
#   4. Binds the backing directory onto /nix
#
# Usage:
#   bind-store.sh [--migrate] [--owner USER] [BACKING_DIR]
#
# Options:
#   --migrate      Move the contents of an existing /nix into BACKING_DIR
#                  before the mount. Without this option the script stops if
#                  /nix already holds a store, because a bind mount hides it.
#   --owner USER   Owner for a backing directory that this script creates.
#                  The default is the owner of the parent directory.
#
# Environment Variables:
#   NIX_STORE_BACKING  - The backing directory, if you give no argument
#
# Prerequisites:
#   - Sudo privileges
#
# Note:
#   The store path stays /nix. Do not set NIX_STORE_DIR to the backing
#   directory instead. Nix writes the absolute store path into its build
#   results, thus a different store path makes every binary in the cache
#   invalid, and nix builds all packages from source.
#
#   A bind mount does not survive a reboot. To make it permanent, add an
#   /etc/fstab entry, or run this script at boot. Use
#   ../google/startup-script.sh when the root disk is disposable, because /etc
#   does not survive either.
################################################################################

set -euo pipefail

MIGRATE=false
OWNER=""
BACKING="${NIX_STORE_BACKING:-}"

usage() {
    printf "Usage: %s [--migrate] [--owner USER] [BACKING_DIR]\n" "$(basename "$0")"
}

# Mounting needs root, but the owner of a new backing directory must not be
# root. Record the caller before sudo hides it.
if [ "$(id -u)" -ne 0 ]; then
    exec sudo -- "$(realpath "$0")" --owner "$(id -un)" "$@"
fi

while [ $# -gt 0 ]; do
    case "$1" in
        --migrate) MIGRATE=true; shift ;;
        --owner) OWNER="$2"; shift 2 ;;
        -h|--help) usage; exit 0 ;;
        -*) printf "Error: unknown option %s\n" "$1" >&2; usage >&2; exit 2 ;;
        *) BACKING="$1"; shift ;;
    esac
done

if [ -z "$BACKING" ]; then
    printf "Error: no backing directory given, and NIX_STORE_BACKING is not set\n" >&2
    usage >&2
    exit 2
fi

is_mounted() {
    awk -v target="$1" '$2 == target { found = 1 } END { exit !found }' /proc/self/mounts
}

if is_mounted /nix; then
    printf "/nix is already a mount point, nothing to do\n"
    exit 0
fi

# Create the backing directory. The owner of the parent is the best guess for
# a home disk: at boot there is no caller to ask.
if [ ! -d "$BACKING" ]; then
    parent="$(dirname "$BACKING")"
    if [ ! -d "$parent" ]; then
        printf "Error: %s does not exist. Is the persistent disk mounted?\n" "$parent" >&2
        exit 1
    fi
    [ -n "$OWNER" ] || OWNER="$(stat -c %U "$parent")"
    printf "creating %s owned by %s\n" "$BACKING" "$OWNER"
    mkdir -p "$BACKING"
    chown "$OWNER" "$BACKING"
fi

# A store already on the root disk would disappear behind the mount. Move it,
# or stop and let the user decide.
if [ -d /nix ] && [ -n "$(ls -A /nix 2>/dev/null)" ]; then
    if ! $MIGRATE; then
        printf "Error: /nix is not empty, and a bind mount would hide it.\n" >&2
        printf "Run again with --migrate to move it into %s, or empty /nix first.\n" "$BACKING" >&2
        exit 1
    fi
    if [ -n "$(ls -A "$BACKING" 2>/dev/null)" ]; then
        printf "Error: both /nix and %s hold data. Delete the one you do not want.\n" "$BACKING" >&2
        exit 1
    fi

    # tar keeps the hard links that nix uses to deduplicate the store. cp and
    # mv break them across filesystems, which can multiply the store size.
    printf "migrating /nix into %s, do not run nix until this completes...\n" "$BACKING"
    tar -C /nix --numeric-owner -cf - . | tar -C "$BACKING" --numeric-owner -xf -

    # A rename on the same filesystem, thus it is immediate. The copy stays
    # until you delete it, or until the root disk is rebuilt.
    mv /nix /nix.pre-bind
    printf "the old store is at /nix.pre-bind, delete it when you are satisfied\n"
fi

mkdir -p /nix
mount --bind "$BACKING" /nix
printf "/nix is now backed by %s\n" "$BACKING"
