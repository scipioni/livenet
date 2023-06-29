#!/bin/sh

sudo virt-install --connect qemu:///system \
    --name testvm \
    --network=bridge:br-livenet \
	--pxe \
    --ram=2048 \
    --vcpus=2 \
	--os-variant=ubuntu22.04 \
    --disk path=/var/lib/libvirt/images/testvm.qcow2,size=40
