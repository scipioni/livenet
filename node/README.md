# Livenet node build and serve


## prereq

- docker compose
- qemu and libvirtd
- pigz
- spice-gtk
```
yay -S qemu-desktop libvirt spice-gtk pigz
yay -R firewalld
sudo systemctl start libvirtd
sudo systemctl enable libvirtd
# add user to libvirt group
sudo su
echo "allow livenet" >> /etc/qemu/bridge.conf
```

create .env from env.sample


## build


```
task build
```

## serve

start nfs/tftp/http server

```
task network (only once)
task start
```

inspect logs with task logs


## customize image

chroot in node live container
```
task cli
```

## reset

reset image build 20230801.00 version

## test vm

```
task vm:bios
task vm:efi
```

connect to client
```
ssh root@192.168.124.18
```
## release

make commit

```
task commit -- 20230801.00
```

and eventually full release
```
task release -- 20230801.00
```


## install node client

on node
```
ln-install --client
```

after boot with
```
task vm
```

## system alternatives and profiles

```
task cli
# create alternatives
/etc/fstab.local.default
/etc/fstab.local.standalone
# update alternatives
ln-mng --profiles

```

profiles are defined with /etc/livenet/local/livenet.conf.nfs.* and are for example:
- default
- special
- standalone


## documentation

/etc/initramfs-tools/*livenet* contains initram system that live in RAM. It has simpler fs that:
- mount remote NFS root
- or mount local root
- run /usr/bin/ln-client in chroot to prepare real os
