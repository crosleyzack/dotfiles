#!/bin/bash

################################################################################
# Universal Disk Cleanup Script
#
# Purpose:
#   Frees disk space held by package managers, build caches, and scanner
#   databases of the tools that the dotfiles install.
#
# Behavior:
#   Detects and cleans all available tools on the system:
#
#   Package Managers:
#   - nix: expire home-manager generations, collect garbage, optimise store
#   - apt (Debian/Ubuntu): autoremove, clean
#   - snap: remove disabled revisions
#   - flatpak: remove unused runtimes
#
#   Development Tools:
#   - pre-commit: remove environments of unused hook repositories
#   - go: remove build cache, test cache, and goimports module index
#   - golangci-lint: remove lint cache
#   - uv: prune unused cache entries
#
#   Containers and Scanners:
#   - docker: remove stopped containers, dangling images, unused networks
#   - buildah: remove dangling images and build cache
#   - trivy: remove all caches and databases
#   - grype: remove vulnerability database
#
#   System:
#   - journald: remove system and user journals older than 2 weeks
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - Sudo privileges (required for apt, snap, and system journal)
#   - Individual tools must be installed for their respective cleanup
#
# Note:
#   Nothing here removes data that a tool cannot fetch or rebuild again.
#   The Go module cache and tagged container images stay, because a
#   download of them again is slow. Scanners download their database on
#   the next scan.
################################################################################

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"

# nix. 10 days matches nix/update.sh, so rollback generations stay available.
if [ -x "$(command -v home-manager)" ]; then
    home-manager expire-generations "-10 days"
fi
if [ -x "$(command -v nix-collect-garbage)" ]; then
    nix-collect-garbage --delete-older-than 10d
    nix store optimise
fi

# apt packages
if [ -x "$(command -v apt)" ]; then
    sudo apt autoremove --yes
    sudo apt clean
fi

# snap keeps old revisions of each snap as disabled
if [ -x "$(command -v snap)" ]; then
    snap list --all | awk '/disabled/{print $1, $3}' | while read -r name rev; do
        sudo snap remove "$name" --revision="$rev"
    done
fi

# flatpak
if [ -x "$(command -v flatpak)" ]; then
    flatpak uninstall --unused --assumeyes
fi

# pre-commit
if [ -x "$(command -v pre-commit)" ]; then
    pre-commit gc
fi

# go. "go clean" does not know the goimports module index, which grows with
# each index build.
if [ -x "$(command -v go)" ]; then
    go clean -cache -testcache
    rm -rf -- "$CACHE_DIR/goimports"
fi

# golangci-lint
if [ -x "$(command -v golangci-lint)" ]; then
    golangci-lint cache clean
fi

# uv
if [ -x "$(command -v uv)" ]; then
    uv cache prune
fi

# docker. No "-a", so tagged images stay.
if [ -x "$(command -v docker)" ]; then
    docker system prune --force
fi

# buildah
if [ -x "$(command -v buildah)" ]; then
    buildah prune
fi

# trivy
if [ -x "$(command -v trivy)" ]; then
    trivy clean --all
fi

# grype
if [ -x "$(command -v grype)" ]; then
    grype db delete
fi

# journald
if [ -x "$(command -v journalctl)" ]; then
    sudo journalctl --vacuum-time=2weeks
    journalctl --user --vacuum-time=2weeks
fi
