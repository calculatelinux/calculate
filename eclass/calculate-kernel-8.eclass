# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

#
# Original Author: © 2007-2009 Mir Calculate, Ltd. 
# Purpose: Installing linux-desktop, linux-server. 
# Build the kernel from source.
# @ECLASS: calculate-kernel-8.eclass
# @MAINTAINER:
# support@calculate.ru
# @AUTHOR:
# Author: Mir Calculate
# @BLURB: Functions for calculate-sources
# @DESCRIPTION:
# This eclass use for calculate-sources ebuild

inherit calculate kernel-2
EXPORT_FUNCTIONS pkg_setup src_unpack src_compile src_install pkg_postinst


REQUIRED_USE="minimal? ( vmlinuz )"

CDEPEND="
	vmlinuz? ( app-arch/xz-utils )
	grub? ( sys-boot/grub )
	firmware? ( || ( sys-kernel/linux-firmware
		sys-firmware/eth-firmware ) )
	sys-apps/kmod[zstd]"

DEPEND="${CDEPEND}
	>=sys-devel/bison-1.875
	>=sys-devel/flex-2.5.4
	themes? ( || ( media-gfx/splash-themes-calculate
		sys-boot/plymouth-calculate-plugin ) )
	!minimal? ( virtual/pkgconfig )
	"

RDEPEND="${CDEPEND} vmlinuz? ( sys-kernel/dracut )"

detect_version
detect_arch

IUSE="+vmlinuz desktop minimal themes firmware +grub"

if [[ ${KV_MAJOR} -lt 3 ]]
then
	die "Eclass is used only for kernel-3"
fi

SLOT=${PV}
EXTRAVERSION="-${KERNELNAME:-calculate}"
KV_FULL="${PV}${EXTRAVERSION}"

S="${WORKDIR}/linux-${KV_FULL}"

calculate-kernel-8_pkg_setup() {
	kernel-2_pkg_setup
	eqawarn "!!! WARNING !!!  WARNING !!!  WARNING !!!  WARNING !!!"
	eqawarn "After the kernel assemble perform command to update modules:"
	eqawarn "  emerge @modules-rebuild"
}

calculate-kernel-8_src_unpack() {
	kernel-2_src_unpack
	cd "${S}"
	local GENTOOARCH="${ARCH}"
	unset ARCH
	emake defconfig || die "kernel configure failed"
	ARCH="${GENTOOARCH}"
}

vmlinuz_clean_localversion() {
	sed -ri 's/^(CONFIG_LOCALVERSION=")[^"]+"/\1"/' .config
	sed -ri 's/^(CONFIG_LOCALVERSION_AUTO)=.*$/# \1 is not set/' .config
	rm -f localversion*
}

vmlinuz_src_compile() {
	# disable sandbox
	local GENTOOARCH="${ARCH}"
	unset ARCH
	cd "${S}"
	vmlinuz_clean_localversion
	emake olddefconfig || die "kernel configure failed"
	emake && emake modules || die "kernel build failed"
	[ -f .config ] && cp .config .config.save
	ARCH="${GENTOOARCH}"
}

calculate-kernel-8_src_compile() {
	use vmlinuz && vmlinuz_src_compile
}

vmlinuz_src_install() {
	# dracut change this files in chroot of ramdisk
	SANDBOX_WRITE="${SANDBOX_WRITE}:/run/blkid:/etc/ld.so.cache~:/etc/ld.so.cache:/etc/mtab"
	cd "${S}"
	dodir /usr/share/${PN}/${PV}/boot
	INSTALL_PATH=${D}/usr/share/${PN}/${PV}/boot emake install
	INSTALL_MOD_PATH=${D} emake modules_install
	/sbin/depmod -b "${D}" "${KV_FULL}"

	cp /etc/dracut.conf dracut.conf
	echo >>dracut.conf
	if use themes
	then
		echo add_dracutmodules+=\" plymouth \" >>dracut.conf
	else
		echo omit_dracutmodules+=\" plymouth \" >>dracut.conf
	fi
	echo add_dracutmodules+=\" calculate video \" >>dracut.conf

	if grep -q CONFIG_RD_ZSTD=y .config &>/dev/null
	then
		RDARCH="--zstd"
	elif grep -q CONFIG_RD_GZIP=y .config &>/dev/null
	then
		RDARCH="--gzip"
	elif grep -q CONFIG_RD_XZ=y .config &>/dev/null
	then
		RDARCH="--xz"
	else
		RDARCH=""
	fi
	/usr/bin/dracut "${RDARCH}" -c dracut.conf -k "${D}/lib/modules/${KV_FULL}" \
		--kver ${KV_FULL} \
		"${D}/usr/share/${PN}/${PV}/boot/initramfs-${KV_FULL}"
	# move firmware to share, because /lib/firmware installation does collisions
	rm dracut.conf
	mv "${D}/lib/firmware" "${D}/usr/share/${PN}/${PV}"
	insinto "/usr/share/${PN}/${PV}/boot/"
	newins .config config-${KV_FULL}

	# recreate symlink in /lib/modules because symlink point to tmp/portage after make install
	rm "${D}/lib/modules/${KV_FULL}/build"
	rm "${D}/lib/modules/${KV_FULL}/source"
	dosym /usr/src/linux-${KV_FULL} \
		"/lib/modules/${KV_FULL}/source" ||
		die "cannot install source symlink"
	dosym /usr/src/linux-${KV_FULL} \
		"/lib/modules/${KV_FULL}/build" || 
		die "cannot install build symlink"
}

# FUNCTION: clean_for_minimal
# DESCRIPTION:
# Clear kernel sources, keeping only need for custom modules compilation
clean_for_minimal() {
	local GENTOOARCH="${ARCH}"
	unset ARCH
	ARCH="${GENTOOARCH}"

	mkdir backup
	cp Module.symvers backup
	emake distclean &>/dev/null || die "cannot perform distclean"
	mv .config.save .config
	ebegin "kernel: >> Running modules_prepare..."
	emake modules_prepare &>/dev/null
	eend $? "Failed modules prepare"
	einfo "Cleaning sources"
	for rmpath in $(ls arch | grep -v x86)
	do
		rm -r arch/$rmpath
	done
	mv backup/Module.symvers .
	rmdir backup
	KEEPLIST="arch/x86/Makefile_32.cpu arch/x86/Makefile \
		include/config/kernel.release include/config/auto.conf \
		Module.symvers \
		scripts/check-local-export \
		scripts/depmod.sh scripts/Makefile.host \
		scripts/gcc-goto.sh scripts/Makefile.headersinst \
		scripts/gcc-version.sh scripts/Makefile.help \
		scripts/Kbuild.include scripts/Makefile.modpost \
		scripts/Makefile.build scripts/basic/fixdep \
		scripts/Makefile.clean scripts/mod/modpost \
		scripts/Makefile.compiler \
		scripts/Makefile.extrawarn scripts/Makefile.kasan \
		scripts/Makefile.gcc-plugins \
		scripts/Makefile.kcov \
		scripts/Makefile.lib scripts/module-common.lds \
		scripts/Makefile.modbuiltin scripts/Makefile.fwinst \
		scripts/Makefile.modfinal \
		scripts/Makefile.modinst scripts/Makefile.asm-generic \
		scripts/Makefile.ubsan \
		scripts/module.lds \
		scripts/modules-check.sh \
		scripts/pahole-flags.sh \
		scripts/subarch.include \
		System.map Kconfig Makefile Kbuild \
		tools/objtool/objtool"
	find . -type f -a \! -wholename ./.config \
		$(echo $KEEPLIST | sed -r 's/(\S+)(\s|$)/-a \! -wholename .\/\1 /g') \
		-a \! -name "*.h" -delete
	find . -type l -delete
	rm -r drivers
	rm -r Documentation
}

calculate-kernel-8_src_install() {
	use vmlinuz && vmlinuz_src_install
	use minimal && clean_for_minimal
	kernel-2_src_install
	if ! use vmlinuz
	then
		dodir /usr/share/${PN}/${PV}/boot
		insinto /usr/share/${PN}/${PV}/boot
		newins .config config-${KV_FULL}
	fi
	use vmlinuz && touch "${D}/usr/src/linux-${KV_FULL}/.calculate"
}

vmlinuz_pkg_postinst() {
	# install kernel into /boot
	calculate_update_ver /boot vmlinuz ${KV_FULL} /usr/share/${PN}/${PV}/boot/vmlinuz-${KV_FULL}
	calculate_update_ver /boot config ${KV_FULL} /usr/share/${PN}/${PV}/boot/config-${KV_FULL}
	calculate_update_ver /boot initramfs ${KV_FULL} /usr/share/${PN}/${PV}/boot/initramfs-${KV_FULL} .img
	calculate_update_ver /boot System.map ${KV_FULL} /usr/share/${PN}/${PV}/boot/System.map-${KV_FULL}
	# install firmware into /
	mkdir -p "${ROOT}/lib/firmware"
	cp -a "${ROOT}/usr/share/${PN}/${PV}/firmware/"* "${ROOT}/lib/firmware/"
	calculate_update_depmod
	calculate_update_modules
}

calculate-kernel-8_pkg_postinst() {
	kernel-2_pkg_postinst

	KV_OUT_DIR=${ROOT}/usr/src/linux-${KV_FULL}
	use vmlinuz && cp -p /usr/share/${PN}/${PV}/boot/System.map* "${KV_OUT_DIR}/System.map"

	if ! use minimal
	then
		cd ${KV_OUT_DIR}
		local GENTOOARCH="${ARCH}"
		unset ARCH
		ebegin "kernel: >> Running modules_prepare..."
		(emake oldconfig && emake modules_prepare) &>/dev/null
		eend $? "Failed modules prepare"
		ARCH="${GENTOOARCH}"
	fi

	use vmlinuz && vmlinuz_pkg_postinst
	use vmlinuz && calculate_fix_lib_modules_contents
}
