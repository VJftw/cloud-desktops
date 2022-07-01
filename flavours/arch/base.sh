#!/usr/bin/env bash
# This script installs a base set of packages and configuration onto Arch Linux.
# - `pacman -Syu`: Updates arch.
set -Exeuo pipefail

# Upgrade system
sudo pacman -Syu --noconfirm

# Install base packages
sudo pacman -S --noconfirm \
    vim \
    inetutils \
    curl \
    htop
