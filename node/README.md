# Livenet node build and serve


## prereq

- docker compose
- qemu and libvirtd
- pigz


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

chroot in node live container
```
task cli
```

## test vm

```
task vm:bios
task vm:efi
```
## release

make release

```
task commit -- 0.0.1
```

## install node client

on node
```
ln-install --client
```

after boot with
```
task vm:bios:local
```



## documentation

/etc/initramfs-tools/*livenet* contains initram system that live in RAM. It has simpler fs that:
- mount remote NFS root
- or mount local root
- run /usr/bin/ln-client in chroot to prepare real os