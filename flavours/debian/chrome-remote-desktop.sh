#!/bin/bash -xe

# Install basic cloud debian tools
apt-get update
apt-get -y install wget cloud-utils

# Google Chrome Remote Desktop
wget https://dl.google.com/linux/direct/chrome-remote-desktop_current_amd64.deb
dpkg --install chrome-remote-desktop_current_amd64.deb || apt-get -y -f install
rm chrome-remote-desktop_current_amd64.deb

# Google Chrome browser
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
dpkg --install google-chrome-stable_current_amd64.deb || apt-get -y -f install
rm google-chrome-stable_current_amd64.deb

# Update GCE OS Login groups
google_oslogin_control activate --norestartsshd
sed -i '/^sshd/ s/$/,chrome-remote-desktop/' /etc/security/group.conf

# Fix Polkit Policy ("Authentication is required to create a color managed device")
sed -i \
    's#<allow_inactive>no</allow_inactive>#<allow_inactive>yes</allow_inactive>#g' \
    /usr/share/polkit-1/actions/org.freedesktop.color.policy
