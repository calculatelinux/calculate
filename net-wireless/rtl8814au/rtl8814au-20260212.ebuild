# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT="b1866ce2b857a8dfe2e147e19eb8eca0a842ce18"

DESCRIPTION="Realtek 8814AU USB WiFi module for Linux kernel"
HOMEPAGE="https://github.com/morrownr/8814au"
SRC_URI="https://github.com/morrownr/8814au/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/8814au-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/linux-sources"

src_prepare() {
	default

	# Replace wrong EXTRA_CFLAGS (stopped working with kernels >= 6.15)
	# with proper CFLAGS_MODULE (available since 2.6.36).
	# Bug 957883
	sed -E -i'' \
	  -e 's/(^|[^A-Za-z0-9_])EXTRA_CFLAGS([^A-Za-z0-9_]|$)/\1CFLAGS_MODULE\2/g' \
	  Makefile || die
}


src_compile() {
	local modlist=( 8814au=net/wireless )
	local modargs=( KSRC="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}
