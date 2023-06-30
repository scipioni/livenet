
# pxe efi boot with grub

- compile ipxe: https://gist.github.com/rikka0w0/50895b82cbec8a3a1e8c7707479824c1
- https://wiki.fysik.dtu.dk/ITwiki/PXE_and_UEFI/
- https://realtechtalk.com/EFI_PXE_grub2_Howto_guide_for_Linux_EFI_PXE_Booting_on_Debian_Mint_Ubuntu_RHEL-2355-articles
- https://gist.github.com/jo-makar/6332a89d2fd034a39aa5b3e619950888
- https://www.kraxel.org/blog/2021/09/vm-network-boot/
## todo qemu efi pxe boot

## todo isc-dhcp offering syslinux


#### Repository originale
#### https://github.com/FlorentTomasin/docker_dhcp_nfs_tftp_server.git

Le directory tftp ed nfs ospitano i rispettivi files
La directory scripts ospita alcuni script di supporto
La directory src il necessario per costruire l'immagine
La directory etc i files di configurazione in binding con il container

.env contiene configurazione/path/variabili 

Per test viene creato un bridge che sarà il parent dell'interfaccia macvlan e in cui si innestano eventuali tap delle VM

```
task network
#sudo ip link add name br_test type bridge
sudo ip addr add 10.1.22.2/24 dev  br-livenet
#sudo ip link set br_test up
```

client --- bridge (10.1.22.254) --- server (10.1.22.254)[dhcp,tftp,nfs] 



Il driver macvlan viene usato in modo simile a quanto segue

```
docker network create -d macvlan --subnet=10.1.22.0/24 --gateway=10.1.22.1 -o parent=br_test macvlan0
```



