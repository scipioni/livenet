#!/bin/bash

cat >${roottmppath}/etc/X11/xorg.conf.d/00-keyboard.conf <<EOF
Section "InputClass"
        Identifier "system-keyboard"
        MatchIsKeyboard "on"
        Option "XkbLayout" "it,us"
        Option "XkbModel" "pc104"
EndSection
EOF
chmod +x ${roottmppath}/etc/X11/xorg.conf.d/00-keyboard.conf
sed -i 's/^XKBLA.*/XKBLAYOUT="it"/' ${roottmppath}/etc/default/keyboard

useradd -u 499 -d /var/tmp install