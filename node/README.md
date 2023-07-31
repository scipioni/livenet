# Livenet node build and serve


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


## documentation

/etc/initramfs-tools/*livenet* contains initram system that live in RAM. It has simpler fs that:
- mount remote NFS root
- or mount local root
- run /usr/bin/ln-client in chroot to prepare real os