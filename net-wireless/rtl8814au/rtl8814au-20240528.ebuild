# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT="d8208c83ecfd9b286f3ea45a7eb7d78d10560670"

DESCRIPTION="Realtek 8814AU USB WiFi module for Linux kernel"
HOMEPAGE="https://github.com/morrownr/8814au"
SRC_URI="https://github.com/morrownr/8814au/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/8814au-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

DEPEND="virtual/linux-sources"

src_compile() {
	local modlist=( 8814au=net/wireless )
	local modargs=( KSRC="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}
