FROM ubuntu:22.04 as base

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker
RUN echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker

RUN DEBIAN_FRONTEND=noninteractive RESUME=auto \
  apt-get update \
  && apt-get install -y \
    linux-image-generic \
    linux-headers-generic \
    linux-firmware \
    initramfs-tools \
    locales \
    dialog \
    efibootmgr \
    iputils-ping \
    iproute2 
  #&& rm -rf /var/lib/apt/lists/*


RUN DEBIAN_FRONTEND=noninteractive RESUME=auto \
  apt-get install -y \
    ubuntu-minimal

RUN DEBIAN_FRONTEND=noninteractive RESUME=auto \
  apt-get install -y \
    gdisk \
    openssh-server \
    pigz

RUN locale-gen en_GB.UTF-8
RUN locale-gen it_IT.UTF-8
RUN update-locale LANG=it_IT.UTF-8 LANGUAGE=it:en_US:en

RUN echo Europe/Rome > /etc/timezone
RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime

RUN useradd -ms /bin/bash ubuntu
RUN usermod -a -G sudo ubuntu
RUN echo "ubuntu:u" | chpasswd


########################################################
####### PXE ############################################
########################################################
FROM base as pxe
ARG TFTP_ROOT=/boot


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

RUN mkdir -p ${TFTP_ROOT}/grub-node ${TFTP_ROOT}/bios ${TFTP_ROOT}/boot
RUN ln -s ${TFTP_ROOT}/boot  ${TFTP_ROOT}/bios/boot

# bios with pxelinux
RUN cp /usr/lib/PXELINUX/pxelinux.0 ${TFTP_ROOT}/bios
RUN cp /usr/lib/syslinux/modules/bios/* ${TFTP_ROOT}/bios


# efi with grub
RUN cp -rf /usr/lib/grub/i386-pc ${TFTP_ROOT}/grub-node
RUN grub-mkimage -d /usr/lib/grub/i386-pc/ -O i386-pc-pxe -o ${TFTP_ROOT}/booti386 -p '/grub-node' pxe tftp
RUN cp -a /usr/lib/grub/x86_64-efi ${TFTP_ROOT}/grub-node/
RUN grub-mkimage -d /usr/lib/grub/x86_64-efi/  -O x86_64-efi -o ${TFTP_ROOT}/grub-node/bootx64.efi -p '/grub-node' efinet tftp





########################################################
####### NFS ############################################
########################################################
FROM pxe as nfs

#RUN bash -c echo "livenet" > /etc/hostname
#RUN echo "127.0.1.1 livenet" >> /etc/hosts



RUN set -x && \
    DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
      openssl \
      nfs-kernel-server \
      iproute2


RUN mkdir -p /var/lib/nfs/rpc_pipefs /var/lib/nfs/v4recovery && \
    echo "rpc_pipefs    /var/lib/nfs/rpc_pipefs rpc_pipefs      defaults        0       0" >> /etc/fstab && \
    echo "nfsd  /proc/fs/nfsd   nfsd    defaults        0       0" >> /etc/fstab


COPY entrypoint.sh /usr/local/bin/
RUN chmod +rx /usr/local/bin/entrypoint.sh
COPY exports /etc/exports

# nfsv4
EXPOSE 2049/tcp

# minihttpd
EXPOSE 8095/tcp


########################################################
####### final ############################################
########################################################


FROM nfs as runtime

COPY ./overlay /tmp/overlay
RUN cp -vR /tmp/overlay/* / && rm -fR /tmp/overlay

RUN mkdir -p /var/cache/livenet

RUN RESUME=auto update-initramfs -c -k all
#RUN /bin/bash -c "source /etc/livenet/livenet.conf && RESUME=auto dpkg-reconfigure linux-image-${KERNEL}"

CMD ["/usr/local/bin/entrypoint.sh"]