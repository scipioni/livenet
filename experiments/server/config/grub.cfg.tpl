#
# DO NOT EDIT THIS FILE
#
# It is automatically generated by grub-mkconfig using templates
# from /etc/grub.d and settings from /etc/default/grub
#

### BEGIN /etc/grub.d/000_proxmox_boot_header ###
#
# This system is booted via proxmox-boot-tool! The grub-config used when
# booting from the disks configured with proxmox-boot-tool resides on the vfat
# partitions with UUIDs listed in /etc/kernel/proxmox-boot-uuids.
# /boot/grub/grub.cfg is NOT read when booting from those disk!
### END /etc/grub.d/000_proxmox_boot_header ###

### BEGIN /etc/grub.d/00_header ###
if [ -s $prefix/grubenv ]; then
  set have_grubenv=true
  load_env
fi
if [ "${next_entry}" ] ; then
   set default="${next_entry}"
   set next_entry=
   save_env next_entry
   set boot_once=true
else
   set default="0"
fi

if [ x"${feature_menuentry_id}" = xy ]; then
  menuentry_id_option="--id"
else
  menuentry_id_option=""
fi

export menuentry_id_option

if [ "${prev_saved_entry}" ]; then
  set saved_entry="${prev_saved_entry}"
  save_env saved_entry
  set prev_saved_entry=
  save_env prev_saved_entry
  set boot_once=true
fi

function savedefault {
  if [ -z "${boot_once}" ]; then
    saved_entry="${chosen}"
    save_env saved_entry
  fi
}
function load_video {
  if [ x$feature_all_video_module = xy ]; then
    insmod all_video
  else
    insmod efi_gop
    insmod efi_uga
    insmod ieee1275_fb
    insmod vbe
    insmod vga
    insmod video_bochs
    insmod video_cirrus
  fi
}

if [ x$feature_default_font_path = xy ] ; then
   font=unicode
else
insmod part_gpt
insmod zfs
set root='tftp,${TFTP_HOST_IP}'
    font="boot/grub/unicode.pf2"
fi

if loadfont $font ; then
  set gfxmode=auto
  load_video
  insmod gfxterm
  set locale_dir=$prefix/locale
  set lang=en_US
  insmod gettext
fi
terminal_output gfxterm
if [ "${recordfail}" = 1 ] ; then
  set timeout=30
else
  if [ x$feature_timeout_style = xy ] ; then
    set timeout_style=menu
    set timeout=5
  # Fallback normal timeout code in case the timeout_style feature is
  # unavailable.
  else
    set timeout=5
  fi
fi

# Enable the lspci module to check if the server has a Radeon card installed
insmod lspci

if [[ lspci | grep -q 'Radeon' ]]; then
   set default="Proxmox VE GNU/Linux IOMMU ON"
fi
### END /etc/grub.d/00_header ###

### BEGIN /etc/grub.d/05_debian_theme ###
set menu_color_normal=cyan/blue
set menu_color_highlight=white/blue
### END /etc/grub.d/05_debian_theme ###

### BEGIN /etc/grub.d/10_linux ###
function gfxmode {
	set gfxpayload="${1}"
}
set linux_gfx_mode=
export linux_gfx_mode
menuentry 'Proxmox VE GNU/Linux' --class proxmox --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple' {
	load_video
	insmod gzio
	insmod part_gpt
	insmod zfs
	set root='tftp,${TFTP_HOST_IP}'
	echo	'Loading Linux 5.13.19-6-pve ...'
	linux	boot/vmlinuz-5.13.19-6-pve root=ZFS=rpool/ROOT/pve-1 ro  root=ZFS=rpool/ROOT/pve-1 boot=zfs quiet intel_iommu=igfx_off intremap=off
	echo	'Loading initial ramdisk ...'
	initrd	boot/initrd.img-5.13.19-6-pve
}
submenu 'Advanced options for Proxmox VE GNU/Linux' $menuentry_id_option 'gnulinux-advanced-dcfde8ffff8e0ebe' {

	menuentry 'Proxmox VE GNU/Linux, with Linux 5.13.19-6-pve' --class proxmox --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.13.19-6-pve-advanced' {
		load_video
		insmod gzio
		insmod part_gpt
		insmod zfs
		set root='tftp,${TFTP_HOST_IP}'
		echo	'Loading Linux 5.13.19-6-pve ...'
		linux	boot/vmlinuz-5.13.19-6-pve root=ZFS=rpool/ROOT/pve-1 ro  root=ZFS=rpool/ROOT/pve-1 boot=zfs quiet intel_iommu=igfx_off intremap=off
		echo	'Loading initial ramdisk ...'
		initrd	boot/initrd.img-5.13.19-6-pve
	}
	menuentry 'Proxmox VE GNU/Linux, with Linux 5.13.19-6-pve (recovery mode)' --class proxmox --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.13.19-6-pve-recovery' {
		load_video
		insmod gzio
		insmod part_gpt
		insmod zfs
		set root='tftp,${TFTP_HOST_IP}'
		echo	'Loading Linux 5.13.19-6-pve ...'
		linux	boot/vmlinuz-5.13.19-6-pve root=ZFS=rpool/ROOT/pve-1 ro single  root=ZFS=rpool/ROOT/pve-1 boot=zfs
		echo	'Loading initial ramdisk ...'
		initrd	boot/initrd.img-5.13.19-6-pve
	}
    menuentry 'Proxmox VE GNU/Linux, with Linux 5.13.19-4-pve' --class proxmox --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.13.19-4-pve-advanced' {
		load_video
		insmod gzio
		insmod part_gpt
		insmod zfs
		set root='tftp,${TFTP_HOST_IP}'
		echo	'Loading Linux 5.13.19-4-pve ...'
		linux	boot/vmlinuz-5.13.19-4-pve root=ZFS=rpool/ROOT/pve-1 ro  root=ZFS=rpool/ROOT/pve-1 boot=zfs quiet intel_iommu=igfx_off intremap=off
		echo	'Loading initial ramdisk ...'
		initrd	boot/initrd.img-5.13.19-4-pve
	}
	menuentry 'Proxmox VE GNU/Linux, with Linux 5.13.19-4-pve (recovery mode)' --class proxmox --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.13.19-4-pve-recovery' {
		load_video
		insmod gzio
		insmod part_gpt
		insmod zfs
		set root='tftp,${TFTP_HOST_IP}'
		echo	'Loading Linux 5.13.19-4-pve ...'
		linux	boot/vmlinuz-5.13.19-4-pve root=ZFS=rpool/ROOT/pve-1 ro single  root=ZFS=rpool/ROOT/pve-1 boot=zfs
		echo	'Loading initial ramdisk ...'
		initrd	boot/initrd.img-5.13.19-4-pve
	}
	menuentry 'Proxmox VE GNU/Linux, with Linux 5.13.19-2-pve' --class proxmox --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.13.19-2-pve-advanced' {
		load_video
		insmod gzio
		insmod part_gpt
		insmod zfs
		set root='tftp,${TFTP_HOST_IP}'
		echo	'Loading Linux 5.13.19-2-pve ...'
		linux	boot/vmlinuz-5.13.19-2-pve root=ZFS=rpool/ROOT/pve-1 ro  root=ZFS=rpool/ROOT/pve-1 boot=zfs quiet intel_iommu=igfx_off intremap=off
		echo	'Loading initial ramdisk ...'
		initrd	boot/initrd.img-5.13.19-2-pve
	}
	menuentry 'Proxmox VE GNU/Linux, with Linux 5.13.19-2-pve (recovery mode)' --class proxmox --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-5.13.19-2-pve-recovery' {
		load_video
		insmod gzio
		insmod part_gpt
		insmod zfs
		set root='tftp,${TFTP_HOST_IP}'
		echo	'Loading Linux 5.13.19-2-pve ...'
		linux	boot/vmlinuz-5.13.19-2-pve root=ZFS=rpool/ROOT/pve-1 ro single  root=ZFS=rpool/ROOT/pve-1 boot=zfs
		echo	'Loading initial ramdisk ...'
		initrd	boot/initrd.img-5.13.19-2-pve
	}
}

menuentry 'Proxmox VE GNU/Linux IOMMU ON' --class proxmox --class gnu-linux --class gnu --class os $menuentry_id_option 'gnulinux-simple' {
	load_video
	insmod gzio
	insmod part_gpt
	insmod zfs
	set root='tftp,${TFTP_HOST_IP}'
	echo	'Loading Linux 5.13.19-6-pve ...'
	linux	boot/vmlinuz-5.13.19-6-pve root=ZFS=rpool/ROOT/pve-1 ro  root=ZFS=rpool/ROOT/pve-1 boot=zfs quiet intel_iommu=on iommu=pt
	echo	'Loading initial ramdisk ...'
	initrd	boot/initrd.img-5.13.19-6-pve-iommu
}
### END /etc/grub.d/10_linux ###

### BEGIN /etc/grub.d/20_linux_xen ###

### END /etc/grub.d/20_linux_xen ###

### BEGIN /etc/grub.d/20_memtest86+ ###
menuentry "Memory test (memtest86+)" {
	insmod part_gpt
	insmod zfs
	set root='tftp,${TFTP_HOST_IP}'
	linux16	boot/memtest86+.bin
}
menuentry "Memory test (memtest86+, serial console 115200)" {
	insmod part_gpt
	insmod zfs
	set root='tftp,${TFTP_HOST_IP}'
	linux16	boot/memtest86+.bin console=ttyS0,115200n8
}
menuentry "Memory test (memtest86+, experimental multiboot)" {
	insmod part_gpt
	insmod zfs
	set root='tftp,${TFTP_HOST_IP}'
	multiboot	boot/memtest86+_multiboot.bin
}
menuentry "Memory test (memtest86+, serial console 115200, experimental multiboot)" {
	insmod part_gpt
	insmod zfs
	set root='tftp,${TFTP_HOST_IP}'
	multiboot	boot/memtest86+_multiboot.bin console=ttyS0,115200n8
}
### END /etc/grub.d/20_memtest86+ ###

### BEGIN /etc/grub.d/30_os-prober ###
### END /etc/grub.d/30_os-prober ###

### BEGIN /etc/grub.d/30_uefi-firmware ###
### END /etc/grub.d/30_uefi-firmware ###

### BEGIN /etc/grub.d/40_custom ###
# This file provides an easy way to add custom menu entries.  Simply type the
# menu entries you want to add after this comment.  Be careful not to change
# the 'exec tail' line above.
### END /etc/grub.d/40_custom ###

### BEGIN /etc/grub.d/41_custom ###
if [ -f  ${config_directory}/custom.cfg ]; then
  source ${config_directory}/custom.cfg
elif [ -z "${config_directory}" -a -f  $prefix/custom.cfg ]; then
  source $prefix/custom.cfg;
fi
### END /etc/grub.d/41_custom ###