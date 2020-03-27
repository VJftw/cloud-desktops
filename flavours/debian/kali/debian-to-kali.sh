#!/bin/bash -e

export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install -y dirmngr

# Add the Kali Linux GPG
apt-key adv --keyserver keyserver.ubuntu.com --recv-keys ED444FF07D8D0BF6

# Use Kali repositories
cat <<EOF > /etc/apt/sources.list
deb http://http.kali.org/kali kali-rolling main non-free contrib
# deb-src http://http.kali.org/kali kali-rolling main non-free contrib
EOF

# Update and install base packages
apt-get update
apt-get -y upgrade
apt-get -y dist-upgrade
apt-get -y autoremove --purge
apt-get -y install kali-linux

# TODO (@northdpole): add wordlists and scripts for building better kali
apt-get -y install \
  kali-linux-top10 \
  exploitdb \
  kali-defaults \
  kali-root-login \
  desktop-base \
  kali-linux-web \
  kali-linux-forensics \
  kali-linux-pwtools \
  cherrytree \
  xfce4 xfce4-places-plugin xfce4-goodies

# Set default XFCE appearance
sed -i 's#<property name="ThemeName".*#<property name="ThemeName" type="string" value="Kali-Dark"/>#' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml
sed -i 's#<property name="IconThemeName".*#<property name="IconThemeName" type="string" value="Flat-Remix-Blue-Dark"/>#' /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xsettings.xml

echo "exec /etc/X11/Xsession /usr/bin/xfce4-session" > /etc/chrome-remote-desktop-session
apt-get install -y xscreensaver
systemctl disable lightdm.service

apt-get -y autoremove --purge
apt-get clean
