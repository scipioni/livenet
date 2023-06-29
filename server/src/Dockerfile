FROM ubuntu:jammy


RUN apt update && \
    apt install --no-install-recommends -y \
        isc-dhcp-server \
        tftpd-hpa \
        nfs-kernel-server \
        iproute2 \
        syslinux \
        syslinux-efi \
        syslinux-common \
        pxelinux \
        memtest86+ \
        iputils-ping \
        debootstrap && \
    # Clean rootfs
    apt-get clean all && \
    apt-get autoremove -y && \
    apt-get purge && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    # Configure DHCP
    touch /var/lib/dhcp/dhcpd.leases && \
    # Configure rpcbind
    mkdir -p /run/sendsigs.omit.d && \
    touch /run/sendsigs.omit.d/rpcbind

# Export the NFS server ports
EXPOSE 111/tcp \
       111/udp \
       2049/tcp \
       2049/udp \
       67/tcp \
       67/udp \
       69/udp


RUN cp /usr/lib/PXELINUX/pxelinux.0 /srv/tftp/
RUN cp /usr/lib/SYSLINUX.EFI/efi64/syslinux.efi /srv/tftp/

RUN cp /usr/lib/syslinux/modules/efi64/ldlinux.e64 /srv/tftp/
RUN cp /usr/lib/syslinux/modules/efi64/libutil.c32 /srv/tftp/
RUN cp /usr/lib/syslinux/modules/efi64/menu.c32 /srv/tftp/

RUN mkdir /srv/tftp/pxelinux.cfg
RUN mkdir /srv/tftp/memtest
RUN cp /boot/memtest86+.bin /srv/tftp/memtest

WORKDIR /

VOLUME ["/etc/dhcp"]
VOLUME ["/etc/default"]

COPY entrypoint.sh /entrypoint.sh
    # Set correct entrypoint permission
RUN chmod u+x /entrypoint.sh

CMD ["/entrypoint.sh"]
