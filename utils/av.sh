#!/bin/bash
#
# av.sh - Audio/Video Device Switcher
#
# DESCRIPTION:
#   Automatically finds and sets audio input (microphone) and video input (camera)
#   devices as system defaults based on a device name pattern. Designed for quickly
#   switching between built-in laptop devices and external USB devices.
#
# REQUIREMENTS:
#   - wpctl (WirePlumber/PipeWire) - standard on Ubuntu 22.04+, Fedora 34+
#   - bash, awk, sed
#
# USAGE:
#   ./av.sh
#
#   To use a different device, modify the DEVICE_NAME environment variable.
#   The script searches case-insensitively for devices containing this string.
#
# EXAMPLES:
#   DEVICE_NAME="logi"     - Matches any Logitech device
#   DEVICE_NAME="laptop"   - Matches "Laptop Camera"
#
# HOW IT WORKS:
#   1. Queries wpctl status for all audio/video devices
#   2. Searches the Sources subsections for devices matching DEVICE_NAME
#   3. Extracts device IDs and sets them as defaults using wpctl set-default
#
# NOTES:
#   - Only searches in "Sources" (input devices), not "Sinks" (output devices)
#   - Audio sources are microphones/line-in
#   - Video sources are cameras/capture devices

set -euo pipefail

# Configuration: Set the device name pattern to search for
# This is matched case-insensitively against device names in wpctl status
DEVICE_NAME="${DEVICE_NAME:-C920}"

# set_default_microphone
#
# Finds and sets the default audio input device (microphone) using wpctl.
set_default_microphone() {
    echo "Looking for $DEVICE_NAME microphone..."

    # Search in Audio section's Sources subsection for the device
    # awk: Extract lines from "Audio" to "Video", flag when in Sources subsection
    # sed: Extract just the numeric device ID (e.g., "102" from " │     102. Device Name")
    local mic_id=$(wpctl status | awk '/Audio/,/^Video/ { if (/Sources:/) in_sources=1; if (in_sources && /'"$DEVICE_NAME"'/) print }' | head -n1 | sed -E 's/^[^0-9]*([0-9]+)\..*/\1/' || true)

    if [ -n "$mic_id" ]; then
        wpctl set-default "$mic_id"
        echo "✓ Set microphone $mic_id as default"
    else
        echo "⚠ No $DEVICE_NAME microphone found"
    fi
}

# set_default_camera
#
# Finds and sets the default video input device (camera) using wpctl.
set_default_camera() {
    echo "Looking for $DEVICE_NAME camera..."

    # Search in Video section's Sources subsection for the device
    # awk: Extract lines from "Video" to "Settings", flag when in Sources subsection
    # sed: Extract just the numeric device ID (e.g., "129" from " │  *  129. Device Name")
    local camera_id=$(wpctl status | awk '/^Video/,/^Settings/ { if (/Sources:/) in_sources=1; if (in_sources && /'"$DEVICE_NAME"'/) print }' | head -n1 | sed -E 's/^[^0-9]*([0-9]+)\..*/\1/' || true)

    if [ -n "$camera_id" ]; then
        wpctl set-default "$camera_id"
        echo "✓ Set camera $camera_id as default"
    else
        echo "⚠ No $DEVICE_NAME camera found"
    fi
}

# Calls each function in sequence to set both audio and video defaults.

echo "=== Setting $DEVICE_NAME devices as default ==="
echo ""

set_default_microphone
echo ""
set_default_camera
echo ""
echo "=== Done ==="