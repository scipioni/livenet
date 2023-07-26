FROM ubuntu:22.04 as base

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get update \
  && apt-get install -y \
    linux-image-generic \
    linux-headers-generic \
    linux-firmware \
    initramfs-tools \
    locales \
    dialog \
    efibootmgr
  #&& rm -rf /var/lib/apt/lists/*



RUN useradd -ms /bin/bash ubuntu
RUN usermod -a -G sudo ubuntu

#USER apprunner

########################################################
####### PXE ############################################
########################################################
FROM base as pxe

RUN DEBIAN_FRONTEND=noninteractive \
  && apt-get install -y \
    tftpd-hpa \
    grub-efi \
    grub-pc-bin \
    pcmemtest \
    pxelinux \
    syslinux \
    syslinux-common \
    mini-httpd

EXPOSE 67/tcp \
       67/udp \
       69/udp

RUN mkdir -p /tftp/grub /tftp/bios /tftp/boot
RUN ln -s /tftp/boot  /tftp/bios/boot

# bios with pxelinux
RUN cp /usr/lib/PXELINUX/pxelinux.0 /tftp/bios
RUN cp /usr/lib/syslinux/modules/bios/* /tftp/bios


# efi with grub
RUN cp -rf /usr/lib/grub/i386-pc /tftp/grub
RUN grub-mkimage -d /usr/lib/grub/i386-pc/ -O i386-pc-pxe -o /tftp/booti386 -p '/grub' pxe tftp
RUN cp -a /usr/lib/grub/x86_64-efi /tftp/grub/
RUN grub-mkimage -d /usr/lib/grub/x86_64-efi/  -O x86_64-efi -o /tftp/grub/bootx64.efi -p '/grub' efinet tftp
RUN cp /boot/pcmemtestx64.efi /tftp/boot/

# pcmemtest
RUN cp /boot/pcmemtest.bin /tftp/boot




########################################################
####### NFS ############################################
########################################################
FROM pxe as nfs

#RUN bash -c echo "livenet" > /etc/hostname
#RUN echo "127.0.1.1 livenet" >> /etc/hosts

RUN locale-gen en_GB.UTF-8
RUN locale-gen it_IT.UTF-8
RUN update-locale LANG=it_IT.UTF-8 LANGUAGE=it:en_US:en

# adjust timezone (later run dpkg-reconfigure tzdata)
#RUN echo Europe/Rome > /etc/timezone
#RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime


RUN set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y openssl nfs-kernel-server && \
    mkdir /exports

RUN mkdir -p /var/lib/nfs/rpc_pipefs /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs    /var/lib/nfs/rpc_pipefs rpc_pipefs      defaults        0       0" >> /etc/fstab && \
    echo "nfsd  /proc/fs/nfsd   nfsd    defaults        0       0" >> /etc/fstab


COPY entrypoint.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/entrypoint.sh
COPY exports /etc/exports


EXPOSE 2049/tcp
#EXPOSE 20048/tcp


FROM nfs

COPY overlay/etc /
COPY overlay/usr/sbin/ln-mng /usr/sbin
COPY overlay/usr/sbin/policy-rc.d /usr/sbin
ENV RESUME auto 
RUN update-initramfs -c -k all

CMD ["/usr/local/bin/entrypoint.sh"]