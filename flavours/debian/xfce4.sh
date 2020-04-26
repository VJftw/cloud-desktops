#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y xfce4 desktop-base task-xfce-desktop

apt-get install -y xscreensaver
systemctl disable lightdm.service

echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session

# Fix Polkit Policy ("Authentication is required to create a color managed device")
sed -i \
    's#<allow_inactive>no</allow_inactive>#<allow_inactive>yes</allow_inactive>#g' \
    /usr/share/polkit-1/actions/org.freedesktop.color.policy
