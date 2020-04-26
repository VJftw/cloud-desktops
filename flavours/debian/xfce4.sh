#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y xfce4 desktop-base task-xfce-desktop

apt-get install -y xscreensaver
systemctl disable lightdm.service

echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session
