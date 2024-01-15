#/bin/bash

#export DEBIAN_FRONTEND=noninteractive
export GREETER_VERSION=3.5.2

apt-get update && \
  xargs -a packages.list sudo DEBIAN_FRONTEND=noninteractive apt install  -qq -y \
  && apt-get clean

  # apt-get install -qq -y \
  # ubuntu-desktop \
  # language-selector-common \
  # language-pack-it \
  # language-pack-en \
  # witalian \
  # wamerican \
  # wbritish \
  # lightdm \
  # lightdm-gtk-greeter \
  # plymouth-themes \
  # plymouth-theme-ubuntu-gnome-logo \
  # mc tree  nano netcat \
  # wget curl \
  # && apt-get clean


apt-add-repository -y ppa:mozillateam/ppa
apt-update && apt-get install --q -y firefox


echo /usr/sbin/lightdm > /etc/X11/default-display-manager 
dpkg-reconfigure -fnoninteractive lightdm

cd /tmp && \
  wget https://github.com/JezerM/web-greeter/releases/download/${GREETER_VERSION}/web-greeter-${GREETER_VERSION}-ubuntu.deb && \
  apt-get install -qq -y ./web-greeter-${GREETER_VERSION}-ubuntu.deb  