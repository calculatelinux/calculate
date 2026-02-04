#!/bin/bash
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

check() {
    return 255
}

depends() {
    # if dmsetup is not installed, then we cannot support fedora/red hat
    # style live images
#?pkg(sys-kernel/dracut)<049#
    [[ $hostonly ]] || echo rootfs-block dmsquash-live 
#!pkg#
    [[ $hostonly ]] || echo rootfs-block dmsquash-live network-legacy network
#pkg#
    return 0
}

installkernel() {
    [[ $hostonly ]] || instmods squashfs loop iso9660
    instmods =drivers/usb/host =drivers/usb/phy
}

install() {
    if ! [[ $hostonly ]]
    then
        inst_multiple umount dmsetup blkid dd losetup grep blockdev cat cut sed rmdir pidof
        inst_hook mount 20 "$moddir/scratch-mount-root.sh"
        inst_hook cmdline 31 "$moddir/iso-scan-rootok.sh"
     	inst_hook pre-pivot 50 "$moddir/copy-resolv.sh"
        inst_script "$moddir/scratch-live-root.sh" "/sbin/dmsquash-live-root"
        inst_script "$moddir/mount-squashfs.sh" "/sbin/mount-squashfs"
        inst_script "$moddir/iso-scan.sh" "/sbin/iso-scan"
        inst_script "$moddir/live-scan.sh" "/sbin/live-scan"
        inst_script "$moddir/nfsroot.sh" "/sbin/nfsroot"
        inst_hook initqueue/timeout 95 "$moddir/live-fallback.sh"
    fi
    echo rd.skipfsck=1 >> "${initdir}/etc/cmdline.d/95-skipfsck.conf"
}
