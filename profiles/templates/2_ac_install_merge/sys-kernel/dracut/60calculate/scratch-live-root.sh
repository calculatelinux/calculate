# Calculate chmod=0755
#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

PATH=/usr/sbin:/usr/bin:/sbin:/bin

if getargbool 0 rd.live.debug -n -y rdlivedebug; then
    exec > /tmp/liveroot.$$.out
    exec 2>> /tmp/liveroot.$$.out
    set -x
fi

[ -z "$1" ] && exit 1
livedev="$1"

# parse various live image specific options that make sense to be
# specified as their own things

ln -s $livedev /run/initramfs/livedev

modprobe squashfs
CMDLINE=$(getcmdline)
for arg in $CMDLINE; do case $arg in ro|rw) liverw=$arg ;; esac; done
# mount the backing of the live image first
mkdir -m 0755 -p /run/initramfs/live
mount -n -t $fstype -o ${liverw:-ro} $livedev /run/initramfs/live
if [ "$?" != "0" ]; then
	die "Failed to mount block device of live image"
	exit 1
fi

/sbin/mount-squashfs

exit 0
