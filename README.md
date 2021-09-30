dracut-ntfsloop: Mount image on NTFS partition
==============================================

This dracut module allows you to use a root system located inside
a disk image on a NTFS partition, similar to how Wubi worked.

## Requirements

* dracut
* fuse, ntfs3 5.15+ kernel driver, kpartx, losetup
* fuse and loop kernel modules available

The disk image should contain a full partition table.
From any linux distro: 
`dd if=/dev/zero of=diskimage.img bs=1M count=10000`
`cfdisk diskimage.img`
`mkfs.ext4 diskimage.img`
`mount diskimage.img /mnt`
Then install any distro on there (chroot tarball is the easiest)

## Installation

* copy the `90ntfsloop` directory to `/usr/lib/dracut/modules.d`
* regenerate your initrd using `dracut -a "ntfsloop" -f /boot/yourinitramfs.img `
* add to your kernel command line: `rd.ntfsloop=/PATH/TO/DEVICE:UUID-OF-DEVICE:PATH/TO/IMAGE/IN/PARTITION`
  where `/PATH/TO/DEVICE` can be like `/dev/sda1` but also `UUID=...`. and `root=UUID=UUID-OF-IMAGE-PARTITION`

## Booting

Easy boot with systemd-boot via EFI
Example config file:

`linux /vmlinuz`
`initrd /initramfs.img`
`options rd.ntfsloop=/dev/sda2:555555:diskimage.img root=UUID=555555`

## Performance

Decent with the new ntfs3 kernel driver

dracut-cifsloop: Mount image from samba share
==============================================

This dracut modules allows you to use a root system located inside
a disk image on a samba share

## Requirements

* dracut
* fuse, mount.cifs, kpartx, losetup
* kernel compiled with `IP: kernel level autoconfiguration and IP: DHCP support`

The disk image should contain a full partition table.
From any linux distro: 
`dd if=/dev/zero of=diskimage.img bs=1M count=10000`
`cfdisk diskimage.img`
`mkfs.ext4 diskimage.img`
`mount diskimage.img /mnt`
Then install any distro on there (chroot tarball is the easiest)


## Installation

* copy the `90cifsloop` directory to `/usr/lib/dracut/modules.d`
* regenerate your initrd using `dracut -a "cifsloop" -f /boot/yourinitramfs.img `
* add to your kernel command line: `rd.cifsloop=//SERVER-IP/SHARE:username=SHARE-USERNAME,password=SHARE-PASSOWRD:PATH/TO/IMAGE/ON/SHARE` 
  and `ip=dhcp root=UUID=UUID-OF-IMAGE-PARTITION`
* disable systemd-networkd `systemctl disable systemd-networkd` on the guest to avoid issues with other networking services

## Booting

Easy boot with systemd-boot via EFI
Example config file:

`linux /vmlinuz`
`initrd /initramfs.img`
`options rd.cifsloop=//192.168.1.10/Share:username=user1,password=mypass:diskimage.img root=UUID=555555 ip=dhcp`
