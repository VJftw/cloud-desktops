#!/usr/bin/env bash
# This script installs a base set of packages and configuration onto Arch Linux.
# - `pacman -Syu`: Updates arch.
# - `paru`: AUR helper that wraps pacman (https://github.com/morganamilo/paru).
set -Exeuo pipefail

# Upgrade system
sudo pacman -Syu --noconfirm

# Install paru
sudo pacman -S --noconfirm --needed base-devel git cargo
builddir=$(mktemp -d)
sudo chown -R nobody:nobody "$builddir"
cwd="$PWD"
cd "$builddir"
sudo -u nobody git clone https://aur.archlinux.org/paru.git
cd "paru"
export CARGO_HOME="$builddir/.cargo"
sudo --preserve-env=CARGO_HOME -u nobody makepkg -s
find "$builddir" -name "*.tar.zst" -print0 | xargs -n 1 -0 sudo -u nobody pacman --noconfirm -U
cd "$cwd"
rm -rf "$builddir"
sudo pacman -R --noconfirm rust

# Autoremove
sudo pacman -Rcns $(pacman -Qdtq)
