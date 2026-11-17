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
#   - npm: remove the package cache
#   - terraform: remove the provider plugin cache
#   - git: remove clean linked worktrees of any repo in $HOME, at any age
#     under .claude/worktrees and after 2 weeks idle elsewhere
#
#   Containers and Scanners:
#   - docker: remove stopped containers, unused networks, dangling images,
#     and images older than a week that no container uses
#   - buildah: remove dangling images and build cache
#   - trivy: remove all caches and databases
#   - grype, cg-grype: remove vulnerability databases
#   - wolfictl: remove cache
#
#   System:
#   - journald: remove system and user journals older than 2 weeks
#   - tracker3: remove the GNOME file index
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
#   The Go module cache and recent container images stay, because a
#   download of them again is slow. Scanners download their database on
#   the next scan, and "terraform init" fetches providers again.
################################################################################

CACHE_DIR="${XDG_CACHE_HOME:-$HOME/.cache}"

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

# npm
if [ -x "$(command -v npm)" ]; then
    npm cache clean --force
fi

# terraform. The .terraform directories stay: each one holds the selected
# workspace, and Terraform does not update their mtime on use.
if [ -x "$(command -v terraform)" ]; then
    rm -rf -- "$HOME/.terraform.d/plugin-cache"
fi

# git linked worktrees of each repo in $HOME. Claude Code's under
# .claude/worktrees go at any age; others go once their index is 2 weeks old.
# No "--force", so git keeps a worktree that has changes or a lock. Branches
# stay. Git records each linked worktree under "<git dir>/worktrees", thus the
# search finds a normal repo and a bare repo alike. A ".claude/worktrees"
# directory also matches the name, and the HEAD test drops it.
if [ -x "$(command -v git)" ]; then
    find "$HOME" -xdev -maxdepth 7 -type d -name worktrees -prune -print 2>/dev/null |
        while read -r admin; do
            gitdir="${admin%/worktrees}"
            [ -f "$gitdir/HEAD" ] || continue
            git --git-dir="$gitdir" worktree list --porcelain | awk '/^worktree /{print substr($0, 10)}' | tail -n +2 |
                while read -r wt; do
                    case "$wt" in
                    */.claude/worktrees/*) ;;
                    *)
                        index="$(git -C "$wt" rev-parse --path-format=absolute --git-dir 2>/dev/null)/index"
                        [ -n "$(find "$index" -mtime +14 2>/dev/null)" ] || continue
                        ;;
                    esac
                    git --git-dir="$gitdir" worktree remove "$wt"
                done
            git --git-dir="$gitdir" worktree prune
        done
fi

# docker. Images a week old that no container uses go; newer ones stay.
if [ -x "$(command -v docker)" ]; then
    docker system prune --force
    docker image prune --all --force --filter "until=168h"
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

# cg-grype and wolfictl keep caches of their own, which "grype db delete"
# does not reach.
rm -rf -- "$CACHE_DIR/cg-grype" "$CACHE_DIR/wolfictl"

# journald
if [ -x "$(command -v journalctl)" ]; then
    sudo journalctl --vacuum-time=2weeks
    journalctl --user --vacuum-time=2weeks
fi

# tracker3 rebuilds its index when it runs; without it the index is stale.
rm -rf -- "$CACHE_DIR/tracker3"

# nix. 10 days matches nix/update.sh, so rollback generations stay available.
if [ -x "$(command -v home-manager)" ]; then
    home-manager expire-generations "-10 days"
fi
if [ -x "$(command -v nix-collect-garbage)" ]; then
    nix-collect-garbage --delete-older-than 10d
    nix store optimise
fi


