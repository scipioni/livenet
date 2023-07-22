#!/bin/sh

# dpkg/apt not start any daemons when things are installed in the chroot

if [ ! "\`cat /etc/hostname\`" = "\`hostname\`" ]; then
    exit 101
fi
