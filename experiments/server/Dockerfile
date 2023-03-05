

FROM debian:bullseye-slim

ARG CONFIG_PATH
ARG TFTP_HOST_IP
ARG TFTP_NETWORK

ENV DEBIAN_FRONTEND noninteractive
ENV DEBCONF_NONINTERACTIVE_SEEN true


COPY config/dnsmasq.conf.tpl config/grub.cfg.tpl config/boot.cfg.tpl "$CONFIG_PATH"/

RUN apt-get update && \
    apt-get install --no-install-recommends -y \
        grub-pc-bin \
        dnsmasq \
        nfs-kernel-server && \
    # Clean rootfs
    apt-get clean all && \
    apt-get autoremove -y && \
    apt-get purge && \
    rm -rf /var/lib/{apt,dpkg,cache,log} && \
    # Configure rpcbind
    mkdir -p /run/sendsigs.omit.d && \
    touch /run/sendsigs.omit.d/rpcbind \
    # Replace variables in boot.cfg file
    && sed -e "s/\${TFTP_HOST_IP}/$TFTP_HOST_IP/" "$CONFIG_PATH"/boot.cfg.tpl > "$CONFIG_PATH"/boot.cfg \
    # Create tftp directory structure
    && grub-mknetdir --net-directory=/tftp --subdir=/boot/grub -d /usr/lib/grub/i386-pc \
    # Rebuild Grub core image with embedded config
    && grub-mkimage -O i386-pc-pxe -o /tftp/boot/grub/i386-pc/core.0 --config=$CONFIG_PATH/boot.cfg -p '(tftp,$TFTP_HOST_IP)/boot/grub' pxe tftp \
    # Replace variables in dnsmasq and grub config files
    && sed -e "s/\${TFTP_NETWORK}/$TFTP_NETWORK/" -e "s/\${TFTP_HOST_IP}/$TFTP_HOST_IP/" "$CONFIG_PATH"/dnsmasq.conf.tpl > /etc/dnsmasq.conf \
    && sed -e "s/\${TFTP_HOST_IP}/$TFTP_HOST_IP/" "$CONFIG_PATH"/grub.cfg.tpl > /tftp/boot/grub/grub.cfg


# Export the NFS server ports
EXPOSE 111/tcp \
       111/udp \
       2049/tcp \
       2049/udp \
       67/tcp \
       67/udp \
       69/udp

WORKDIR /

#VOLUME ["/etc/dhcp"]
#VOLUME ["/etc/default"]

COPY entrypoint.sh /entrypoint.sh
    # Set correct entrypoint permission
RUN chmod u+x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]