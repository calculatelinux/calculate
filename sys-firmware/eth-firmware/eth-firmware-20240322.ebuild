# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MYPN=linux-firmware
MYP=linux-firmware-${PV}

GIT_COMMIT="e068ccf01a2afc2d9c689f5d3b0cb715cc1d4824"
SRC_URI="https://git.kernel.org/cgit/linux/kernel/git/firmware/linux-firmware.git/snapshot/linux-firmware-${GIT_COMMIT}.tar.gz -> ${MYP}.tar.gz"
KEYWORDS="amd64"

DESCRIPTION="Binary firmware for Realtek Ethernet"
HOMEPAGE="https://git.kernel.org/?p=linux/kernel/git/firmware/linux-firmware.git"

LICENSE="linux-firmware ( BSD ISC MIT no-source-code ) GPL-2 GPL-2+ freedist"
SLOT="0"

RDEPEND="!sys-kernel/linux-firmware"

RESTRICT="binchecks strip"

src_unpack() {
	default
	# rename directory from git snapshot tarball
	mv ${MYPN}-*/ ${P} || die
}

src_install() {
	insinto /lib/firmware/
	doins -r rtl_nic
}
