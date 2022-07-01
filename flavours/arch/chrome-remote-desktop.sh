#!/usr/bin/env bash
# This script installs a chrome-remote-desktop from the AUR.
set -Eeuox pipefail

sudo pacman -S --noconfirm --needed base-devel git

build_deps=(
    "gtk3"
    "libutempter"
    "libxss"
    "nss"
    "python-psutil"
    "xorg-server-xvfb"
    "xorg-setxkbmap"
    "xorg-xauth"
    "xorg-xdpyinfo"
    "xorg-xrandr"
)

sudo pacman -S --noconfirm --needed "${build_deps[@]}"

builddir=$(mktemp -d)
sudo chown -R nobody:nobody "$builddir"
cwd="$PWD"
cd "$builddir"

sudo -u nobody git clone https://aur.archlinux.org/chrome-remote-desktop.git
cd chrome-remote-desktop
sudo -u nobody makepkg -s

find "$builddir" -name "*.tar.zst" -print0 | xargs -n 1 -0 \
    sudo pacman --noconfirm -U

cd "$cwd"
rm -rf "$builddir"
