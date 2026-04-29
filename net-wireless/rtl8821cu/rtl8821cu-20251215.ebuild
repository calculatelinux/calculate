# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT="7f63a9da2e8ed83403f6f920e9b1628a37b38ef4"

DESCRIPTION="Realtek USB WiFi Adapters based on 8811CU/8821CU/8821CUH/8731AU Chipsets"
HOMEPAGE="https://github.com/morrownr/8821cu-20210916"
SRC_URI="https://github.com/morrownr/8821cu-20210916/archive/${COMMIT}.tar.gz -> rtl8821cu-${PV}.tar.gz"

S="${WORKDIR}/8821cu-20210916-${COMMIT}"

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
	local modlist=( 8821cu=net/wireless )
	local modargs=( KSRC=${KV_OUT_DIR} )
#	local -x USER_EXTRA_CFLAGS="-I${S}/include/example"
	linux-mod-r1_src_compile
}
