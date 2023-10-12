FROM ubuntu:22.04 as base

ARG DEBIAN_FRONTEND=noninteractive
ARG RESUME=auto

RUN echo 'APT::Install-Suggests "0";' >> /etc/apt/apt.conf.d/00-docker \
  && echo 'APT::Install-Recommends "0";' >> /etc/apt/apt.conf.d/00-docker 

RUN apt-get update \
  && apt-get install -qq -y \
  linux-image-generic \
  linux-headers-generic \
  linux-firmware \
  initramfs-tools \
  locales \
  tzdata \
  dialog \
  apt-utils \
  efibootmgr \
  dosfstools \
  iputils-ping \
  iproute2 \
  strace \
  gdisk \
  openssh-server \
  pigz \
  rsync \
  parted \
  psmisc \
  vim \
  && apt-get clean

RUN locale-gen en_GB.UTF-8 \
  && locale-gen it_IT.UTF-8 \
  && update-locale LANG=it_IT.UTF-8 LANGUAGE=it:en_US:en \
  && echo Europe/Rome > /etc/timezone \
  && cp /usr/share/zoneinfo/Europe/Rome /etc/localtime

RUN apt-get install -qq -y \
  ubuntu-minimal \
  network-manager \
  && apt-get clean

RUN useradd -ms /bin/bash ubuntu \
  && usermod -a -G sudo ubuntu \
  && echo "ubuntu:u" | chpasswd


########################################################
####### PXE ############################################
########################################################
FROM base as pxe
ARG TFTP_ROOT=/boot

RUN DEBIAN_FRONTEND=noninteractive \
  apt-get install -y \
  tftpd-hpa \
  grub-efi \
  grub-pc-bin \
  pcmemtest \
  pxelinux \
  syslinux \
  syslinux-common \
  mini-httpd \
  && apt-get clean

RUN mkdir -p ${TFTP_ROOT}/grub-node ${TFTP_ROOT}/bios ${TFTP_ROOT}/boot \
  && ln -s ${TFTP_ROOT}/boot  ${TFTP_ROOT}/bios/boot

# bios with pxelinux
RUN cp /usr/lib/PXELINUX/pxelinux.0 ${TFTP_ROOT}/bios \
  && cp /usr/lib/syslinux/modules/bios/* ${TFTP_ROOT}/bios

# efi with grub
RUN cp -rf /usr/lib/grub/i386-pc ${TFTP_ROOT}/grub-node \
  && grub-mkimage -d /usr/lib/grub/i386-pc/ -O i386-pc-pxe -o ${TFTP_ROOT}/booti386 -p '/grub-node' pxe tftp \
  && cp -a /usr/lib/grub/x86_64-efi ${TFTP_ROOT}/grub-node/ \
  && grub-mkimage -d /usr/lib/grub/x86_64-efi/  -O x86_64-efi -o ${TFTP_ROOT}/grub-node/bootx64.efi -p '/grub-node' efinet tftp

# minihttpd
EXPOSE 8095/tcp

# tftp
EXPOSE 67/udp
EXPOSE 69/udp

########################################################
####### NFS ############################################
########################################################
FROM pxe as nfs
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update
#RUN DEBIAN_FRONTEND=noninteractive apt-get install -qq -y \
RUN apt-get install -qq -y \
  openssl \
  nfs-kernel-server \
  && apt-get clean

RUN mkdir -p /var/lib/nfs/rpc_pipefs /var/lib/nfs/v4recovery && \
  echo "rpc_pipefs    /var/lib/nfs/rpc_pipefs rpc_pipefs      defaults        0       0" >> /etc/fstab && \
  echo "nfsd  /proc/fs/nfsd   nfsd    defaults        0       0" >> /etc/fstab

COPY entrypoint.sh /usr/local/bin/
COPY exports /etc/exports
RUN chmod +rx /usr/local/bin/entrypoint.sh

# nfsv4
EXPOSE 2049/tcp

########################################################
####### packages #######################################
########################################################
FROM nfs as packages
ARG DEBIAN_FRONTEND=noninteractive
# RUN DEBIAN_FRONTEND=noninteractive \
RUN  apt-get update && \
  apt-get install -qq -y \
  ubuntu-desktop \
  language-selector-common \
  language-pack-it \
  witalian \
  language-pack-en \
  wamerican \
  wbritish \
  lightdm \
  lightdm-gtk-greeter \
  plymouth-themes \
  plymouth-theme-ubuntu-gnome-logo \
  mc tree  nano netcat \
  && apt-get clean

# settiamo lightdm al posto di gdm3
RUN echo /usr/sbin/lightdm > /etc/X11/default-display-manager \
  && dpkg-reconfigure -fnoninteractive lightdm

########################################################
####### overlay and initramfs ##########################
########################################################
FROM packages

# COPY ./overlay /tmp/overlay
# RUN cp -vR /tmp/overlay/* / \
#   && rm -fR /tmp/overlay \
#   && mkdir -p /var/cache/livenet

COPY ./overlay/ /
RUN mkdir -p /var/cache/livenet
RUN RESUME=auto update-initramfs -c -k all
RUN ln-mng --profiles

CMD ["/usr/local/bin/entrypoint.sh"]
