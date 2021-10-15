# Calculate exec=/bin/sh cl_ebuild_phase!=&&cl_chroot_status==off&&cl_system_boot_set==off
/sbin/depmod -a
modprobe -a vboxdrv vboxnetflt vboxnetadp
true
