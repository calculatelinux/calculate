# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit linux-mod

COMMIT="0401e4754637144bb7480aafd6b89d93ed97825d"

DESCRIPTION="Realtek 8821(*U)/8811CU/8812A/8192E/8814A/8822B/8723(*U)/8188E(**) module for Linux kernel"
HOMEPAGE="https://github.com/brektrou/rtl8821CU"
SRC_URI="https://github.com/brektrou/rtl8821CU/archive/${COMMIT}.zip -> rtl8821cu-${PV}.zip"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND="virtual/linux-sources"
RDEPEND=""

S="${WORKDIR}/rtl8821CU-${COMMIT}"

MODULE_NAMES="8821cu(net/wireless)"
BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"

src_unpack() {
	unpack "${A}"
	cd "${S}"
}

pkg_setup() {
	linux-mod_pkg_setup
	BUILD_PARAMS="KERN_DIR=${KV_DIR} KSRC=${KV_DIR} KERN_VER=${KV_FULL} O=${KV_OUT_DIR} V=1 KBUILD_VERBOSE=1"
}

src_compile(){
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
}

pkg_postinst() {
	linux-mod_pkg_postinst
}

