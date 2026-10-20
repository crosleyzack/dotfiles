#!/bin/bash

################################################################################
# Firefox apt Install/Uninstall Script (replaces the snap on Ubuntu)
#
# Purpose:
#   apt installer that replaces the snap Firefox on Ubuntu. Ubuntu's own
#   "firefox" package is a shim that installs the snap, so this script installs
#   native Firefox from Mozilla's apt repository instead.
#
# Usage:
#   install.sh [install|uninstall]    (default: install)
#
# Behavior (install):
#   1. Downloads Mozilla's signing key and verifies its fingerprint
#   2. Adds the Mozilla apt repository, signed by that key
#   3. Pins the Mozilla repository above Ubuntu's archive
#   4. Removes the Firefox snap (a snap snapshot is kept) and the apt shim
#   5. Installs Firefox from Mozilla's repository
#
# Behavior (uninstall):
#   1. Removes the Firefox package
#   2. Removes the Mozilla apt source, pin, and signing key
#   3. Does not reinstall the snap and does not touch ~/.mozilla
#
# Environment Variables:
#   None
#
# Prerequisites:
#   - Ubuntu (other Debian-based distributions work but are untested)
#   - apt, wget, and gpg installed
#   - Sudo privileges
#
# Reference:
#   https://support.mozilla.org/kb/install-firefox-linux#w_install-firefox-deb-package-for-debian-based-distributions
################################################################################

set -euo pipefail

KEY_FILE="/etc/apt/keyrings/packages.mozilla.org.asc"
KEY_URL="https://packages.mozilla.org/apt/repo-signing-key.gpg"
SOURCE_FILE="/etc/apt/sources.list.d/mozilla.list"
PIN_FILE="/etc/apt/preferences.d/mozilla"
# Published on Mozilla's install page. The script aborts if the key differs.
KEY_FINGERPRINT="35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3"

install_firefox() {
    for tool in apt wget gpg; do
        if [[ -z "$(command -v "$tool")" ]]; then
            echo "$tool must be installed"
            exit 1
        fi
    done

    TMP_KEY="$(mktemp)"
    trap 'rm -f "$TMP_KEY"' EXIT

    wget -q "$KEY_URL" -O "$TMP_KEY"

    ACTUAL_FINGERPRINT="$(gpg -n -q --import --import-options import-show "$TMP_KEY" | awk '/pub/{getline; gsub(/^ +| +$/,""); print}')"
    if [[ "$ACTUAL_FINGERPRINT" != "$KEY_FINGERPRINT" ]]; then
        echo "Mozilla key fingerprint mismatch"
        echo "expected: $KEY_FINGERPRINT"
        echo "actual:   $ACTUAL_FINGERPRINT"
        exit 1
    fi

    sudo install -d -m 0755 /etc/apt/keyrings
    sudo install -m 0644 "$TMP_KEY" "$KEY_FILE"

    echo "deb [signed-by=$KEY_FILE] https://packages.mozilla.org/apt mozilla main" |
        sudo tee "$SOURCE_FILE" >/dev/null

    # Without the pin, apt prefers Ubuntu's higher-versioned snap shim.
    printf 'Package: *\nPin: origin packages.mozilla.org\nPin-Priority: 1000\n' |
        sudo tee "$PIN_FILE" >/dev/null

    if [[ -n "$(command -v snap)" ]] && snap list firefox >/dev/null 2>&1; then
        sudo snap remove firefox
    fi
    sudo apt-get remove -y firefox || true

    sudo apt-get update
    sudo apt-get install -y firefox

    echo "Firefox installed from Mozilla apt repository!"
}

uninstall_firefox() {
    sudo apt-get remove -y firefox || true
    sudo rm -f "$SOURCE_FILE" "$PIN_FILE" "$KEY_FILE"
    sudo apt-get update

    echo "Firefox and the Mozilla apt repository removed!"
}

case "${1:-install}" in
install) install_firefox ;;
uninstall) uninstall_firefox ;;
*)
    echo "usage: $0 [install|uninstall]"
    exit 1
    ;;
esac
