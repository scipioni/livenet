#!/bin/bash

# Make sure we react to these signals by running stop() when we see them - for clean shutdown
# And then exiting
#trap "stop; exit 0;" TERM INT

stop()
{
# We're here because we've seen SIGTERM, likely via a Docker stop command or similar
# Let's shutdown cleanly
    # echo "SIGTERM caught, terminating process(es)..."
    # echo "NFS Terminate..."
    # exportfs -uav
    # service nfs-kernel-server stop
    echo "TFTP Terminate..."
    #service tftpd-hpa stop
    service atftpd stop
    # echo "DHCP Terminate..."
    # service isc-dhcp-server stop

    exit 0
}

trap stop SIGTERM SIGINT

start()
{
    echo "Starting services..."
    # echo "DHCP init..."
    # service isc-dhcp-server start
    echo "TFTP init..."
    service tftpd-hpa start
    #in.tftpd -L -a :69 -B1300 -R 49000:49100 --secure --ipv4 --create --permissive -v /tftp &

    #service atftpd start
    # echo "NFS init..."
    # service rpcbind start
    # service nfs-common start
    # service nfs-kernel-server start
    # exportfs -rva
    mini_httpd -p 8095 -d /tftp -l /dev/stdout -D &
    
    #cd /tftp
    #spark -port 8095 -path / &

    echo "Started..."
    #while true; do sleep 1; done
    sleep infinity &
    wait
    #exit 0
}

start
