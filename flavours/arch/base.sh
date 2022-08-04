#!/usr/bin/env bash
# This script installs a base set of packages and configuration onto Arch Linux.
# - `pacman -Syu`: Updates arch.
set -Exeuo pipefail

# Upgrade system keyrings
pacman -Sy archlinux-keyring --noconfirm
pacman -Su --noconfirm

# Upgrade system
pacman -Syu --noconfirm

# Install base packages
sudo pacman -S --noconfirm \
    vim \
    inetutils \
    curl \
    htop
