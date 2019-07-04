# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
inherit linux-mod

COMMIT="1907b2d9874dc8d8262ce3808db570149ebd8d0e"

DESCRIPTION="Realtek 8821(*U)/8811CU/8812A/8192E/8814A/8822B/8723(*U)/8188E(**) module for Linux kernel"
HOMEPAGE="https://github.com/ulli-kroll/rtl8821cu"
SRC_URI="https://github.com/ulli-kroll/rtl8821cu/archive/${COMMIT}.zip -> rtl8821cu-${PV}.zip"

LICENSE="GPL-2"
KEYWORDS="amd64 x86"

DEPEND="virtual/linux-sources"
RDEPEND=""

S="${WORKDIR}/rtl8821cu-${COMMIT}"

MODULE_NAMES="rtl8821cu(net/wireless)"
BUILD_TARGETS="all"
BUILD_TARGET_ARCH="${ARCH}"

src_unpack() { 
        unpack "${A}"
        cd "${S}"
}

pkg_setup() {
        linux-mod_pkg_setup
}

src_compile(){
        linux-mod_src_compile
}

src_install() {
        linux-mod_src_install
}
