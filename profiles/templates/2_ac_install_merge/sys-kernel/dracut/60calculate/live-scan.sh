# Calculate chmod=0755
#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh

type getarg >/dev/null 2>&1 || . /lib/dracut-lib.sh

PATH=/usr/sbin:/usr/bin:/sbin:/bin

LIVEPATH=/run/initramfs/livescan

ismounted "$LIVEPATH" && exit 0

mkdir -p "$LIVEPATH"

check_for_live() {
    [[ -f $LIVEPATH/livecd ]] && cat "$LIVEPATH/livecd" | grep -q calculate &>/dev/null
}

do_live_scan() {
    local _name
    local dev
    for dev in /dev/disk/by-uuid/*; do
        _name=$(dev_unit_name "$dev")
        [ -e /tmp/livescan-${_name} ] && continue
        > /tmp/livescan-${_name}
        mount -t auto -o ro "$dev" "$LIVEPATH" || continue
        if check_for_live; then
            umount "$LIVEPATH"
            /sbin/initqueue --settled --onetime --unique /sbin/dmsquash-live-root $dev
            exit 0
        else
            umount "$LIVEPATH"
        fi
    done
}

do_live_scan

rmdir "/run/initramfs/livescan"
exit 1
