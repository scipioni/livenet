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


FROM base

#RUN bash -c echo "livenet" > /etc/hostname
#RUN echo "127.0.1.1 livenet" >> /etc/hosts

RUN locale-gen en_GB.UTF-8
RUN locale-gen it_IT.UTF-8
RUN update-locale LANG=it_IT.UTF-8 LANGUAGE=it:en_US:en

# adjust timezone (later run dpkg-reconfigure tzdata)
#RUN echo Europe/Rome > /etc/timezone
#RUN cp /usr/share/zoneinfo/Europe/Rome /etc/localtime


