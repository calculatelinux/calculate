# Calculate chmod=0755
#!/bin/sh
# -*- mode: shell-script; indent-tabs-mode: nil; sh-basic-offset: 4; -*-
# ex: ts=8 sw=4 sts=4 et filetype=sh
# live images are specified with
# root=live:backingdev

isofile=$(getarg iso-scan/filename)

if [ -n "$isofile" -a "$root" = "live" ]; then
    rootok=1
#?pkg(sys-kernel/dracut)>=044#
    wait_for_dev -n /dev/mapper/live-rw
#pkg#
fi
