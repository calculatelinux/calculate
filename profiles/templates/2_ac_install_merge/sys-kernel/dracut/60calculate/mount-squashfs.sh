# Calculate chmod=0755
#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

PATH=/usr/sbin:/usr/bin:/sbin:/bin

live_dir=$(getarg rd.live.dir -d live_dir )
squash_image=$(getarg rd.live.squashimg -d loop)
[ -z "$squash_image" ] && squash_image="livecd.squashfs"

getargbool 0 rd.live.ram -d -y live_ram -d -y rd.live.ram=1 && live_ram="yes"

# we might have an embedded fs image on squashfs (compressed live)
if [ -e /run/initramfs/live/${live_dir}/${squash_image} ]; then
    SQUASHED="/run/initramfs/live/${live_dir}/${squash_image}"
fi

do_cache() {
    allmemory=0
    for i in $(cat /proc/meminfo | grep -e ^MemFree -e ^Cached | \
        cut -d: -f2 | cut -dk -f1 | sed -e "s/^\s*//") ;
    do
        allmemory=$((${allmemory} + $i))
    done

    # getting size tmpfs of default
    let curtfs=${allmemory}/2

    # getting size of image
    let imagesize=`ls -la ${SQUASHED} | sed -r -n 's/(\S*\s*){4}(\S*).*/\2/p'`/20000*21
    let addon=${imagesize}/7
    if [[ ${curtfs} -gt $(( ${imagesize} + ${addon} )) ]];
    then
        newsize=${curtfs}
    else
        newsize=$(( ${addon} + ${imagesize} ))
    fi

    if [[ ${newsize} -lt ${allmemory} ]];
    then
        LIVECACHE=/run/initramfs/livecache
        mkdir -m 0755 -p $LIVECACHE
        mount -o remount,size=${newsize}k -t tmpfs tmpfs /run
        echo "Copying live image to RAM..."
        echo "(this may take a few minutes)"
        dd if=$SQUASHED of=${LIVECACHE}/livecd.squashfs bs=512 2> /dev/null
        if [ $? -ne 0 ]
        then
            bad_msg "Failed to cache the loop file! Lack of space?"
            umount ${LIVECACHE}
        else
            SQUASHED="${LIVECACHE}/livecd.squashfs"
            echo "Unmounting media from /var/initramfs/live"
            umount -nd /run/initramfs/live
            [[ -d /run/initramfs/isoscan ]] && umount -nd /run/initramfs/isoscan
        fi
    else
        echo "Too low memory for cache the loop file." 1>&2
    fi
}

if [ -e "$SQUASHED" ] ; then
    if [ -n "$live_ram" ] ; then
        do_cache
    fi

    SQUASHED_LOOPDEV=$( losetup -f )
    losetup -r $SQUASHED_LOOPDEV $SQUASHED
    mkdir -m 0755 -p /run/initramfs/squashfs
    mount -n -t squashfs -o ro $SQUASHED_LOOPDEV /run/initramfs/squashfs
fi

ROOTFLAGS="$(getarg rootflags)"
if [ -n "$ROOTFLAGS" ]; then
    ROOTFLAGS="-o $ROOTFLAGS"
else
    ROOTFLAGS="-o udba=reval,br:/overlay=rw,/run/initramfs/squashfs=ro"
fi

ln -s ${SQUASHED_LOOPDEV} /dev/mapper/live-rw
#?pkg(sys-kernel/dracut)>=045#
ln -s ${SQUASHED_LOOPDEV} /run/rootfsbase
#pkg#
#?pkg(sys-kernel/dracut)>=049#
ln -s ${SQUASHED_LOOPDEV} /dev/root
#pkg#

need_shutdown

exit 0
