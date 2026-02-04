# Calculate chmod=0755
#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh
. /lib/nfs-lib.sh

[ "$#" = 3 ] || exit 1

# root is in the form root=nfs[4]:[server:]path[:options], either from
# cmdline or dhcp root-path
netif="$1"
root="$2"
NEWROOT="$3"

nfs_to_var $root $netif
[ -z "$server" ] && die "Required parameter 'server' is missing"

mkdir -m 0755 -p /run/initramfs/live

mount_nfs $root /run/initramfs/live $netif && { [ -e /dev/root ] || ln -s null /dev/root ; }

/sbin/mount-squashfs
echo '[ -e /run/initramfs/squashfs/proc ]' > $hookdir/initqueue/finished/nfsroot.sh

need_shutdown
