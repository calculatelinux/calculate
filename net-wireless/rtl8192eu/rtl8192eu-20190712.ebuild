# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit linux-mod linux-info

COMMIT="13b9c39980a14bebe5178c044cd24ea8aeb845da"

DESCRIPTION="Realtek 8192EU module for Linux kernel"
HOMEPAGE="https://github.com/Mange/rtl8192eu-linux-driver"
SRC_URI="https://github.com/Mange/rtl8192eu-linux-driver/archive/${COMMIT}.zip -> rtl8192eu-${PV}.zip"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND="virtual/linux-sources"
RDEPEND=""

S="${WORKDIR}/rtl8192eu-linux-driver-${COMMIT}"

MODULE_NAMES="8192eu(net/wireless)"
BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"

CONFIG_CHECK="!RTL8XXXU"
ERROR_RLT8XXXU="Module RTL8XXXU exists in the .config but shouldn't!"

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
