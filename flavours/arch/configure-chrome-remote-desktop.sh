#!/usr/bin/env bash
# This script configures Chrome Remote Desktop to use XFCE4 for every user that
# logs into the system.

if [ -n "$HOME" ]; then
    cat << 'EOF' > "$HOME/.chrome-remote-desktop-session"
export $(dbus-launch)
exec startxfce4
EOF

    mkdir -p "$HOME/.config/chrome-remote-desktop"
    touch "$HOME/.config/chrome-remote-desktop/Size" || true
fi
