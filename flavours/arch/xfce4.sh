#!/usr/bin/env bash
set -Eeuox pipefail

sudo pacman -S --noconfirm xfce4 xfce4-goodies

echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" \
    > /etc/chrome-remote-desktop-session
