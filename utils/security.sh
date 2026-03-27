#!/bin/sh

# default all files to only editable by owner
umask 022

# allow outgoing connections but not incoming
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw enable

# Create a new sudoers configuration file
echo 'Defaults timestamp_timeout=1' | sudo tee /etc/sudoers.d/timeout
sudo chmod 0440 /etc/sudoers.d/timeout
sudo visudo -c

################################################################################
# Security Status Verification
################################################################################

echo ""
echo "=== Security Status Checks ==="
echo ""

# Check AppArmor status
if command -v aa-status >/dev/null 2>&1; then
    echo "AppArmor Status:"
    if sudo aa-status --enabled 2>/dev/null; then
        echo "  ✓ AppArmor is enabled and active"
        PROFILES_ENFORCING=$(sudo aa-status 2>/dev/null | grep "profiles are in enforce mode" | awk '{print $1}')
        PROFILES_COMPLAIN=$(sudo aa-status 2>/dev/null | grep "profiles are in complain mode" | awk '{print $1}')
        echo "  - Profiles in enforce mode: $PROFILES_ENFORCING"
        echo "  - Profiles in complain mode: $PROFILES_COMPLAIN"
    else
        echo "  ✗ WARNING: AppArmor is installed but not enabled"
    fi
elif command -v getenforce >/dev/null 2>&1; then
    echo "SELinux Status:"
    SELINUX_STATUS=$(getenforce 2>/dev/null)
    if [ "$SELINUX_STATUS" = "Enforcing" ]; then
        echo "  ✓ SELinux is in enforcing mode"
    elif [ "$SELINUX_STATUS" = "Permissive" ]; then
        echo "  ⚠ WARNING: SELinux is in permissive mode (not enforcing)"
    else
        echo "  ✗ WARNING: SELinux is disabled"
    fi
else
    echo "Mandatory Access Control:"
    echo "  ✗ WARNING: Neither AppArmor nor SELinux detected"
    echo "  Consider installing AppArmor (apt install apparmor) or SELinux"
fi

echo ""

# Check LUKS encryption status
echo "LUKS Encryption Status:"
if command -v lsblk >/dev/null 2>&1; then
    ENCRYPTED_DEVICES=$(lsblk -f | grep -i "crypto_LUKS" | wc -l)
    if [ "$ENCRYPTED_DEVICES" -gt 0 ]; then
        echo "  ✓ Found $ENCRYPTED_DEVICES LUKS encrypted device(s)"
        lsblk -f | grep -i "crypto_LUKS" | awk '{print "  - " $1 " (" $2 ")"}'
        # Check if root is on encrypted device
        if lsblk -f | grep -E "/$" | grep -q "crypt"; then
            echo "  ✓ Root filesystem is on encrypted device"
        else
            echo "  ⚠ WARNING: Root filesystem does not appear to be encrypted"
        fi
    else
        echo "  ✗ WARNING: No LUKS encrypted devices detected"
        echo "  Consider enabling full-disk encryption on next OS install"
    fi
else
    echo "  ? Cannot verify - lsblk not available"
fi

echo ""

# Check Secure Boot status
echo "Secure Boot Status:"
if command -v mokutil >/dev/null 2>&1; then
    SB_STATUS=$(mokutil --sb-state 2>/dev/null)
    if echo "$SB_STATUS" | grep -q "SecureBoot enabled"; then
        echo "  ✓ Secure Boot is enabled"
    elif echo "$SB_STATUS" | grep -q "SecureBoot disabled"; then
        echo "  ⚠ WARNING: Secure Boot is disabled"
        echo "  Enable in UEFI/BIOS settings for additional boot security"
    else
        echo "  ? Unable to determine Secure Boot status"
    fi
elif [ -f /sys/firmware/efi/efivars/SecureBoot-* ]; then
    # Alternative check via EFI variables
    if od -An -t u1 /sys/firmware/efi/efivars/SecureBoot-* 2>/dev/null | grep -q "1$"; then
        echo "  ✓ Secure Boot is enabled"
    else
        echo "  ⚠ WARNING: Secure Boot is disabled"
        echo "  Enable in UEFI/BIOS settings for additional boot security"
    fi
else
    echo "  ⚠ System may not support Secure Boot (no EFI variables found)"
    echo "  This is expected on legacy BIOS systems"
fi

echo ""
echo "=== Security checks complete ==="
echo ""

