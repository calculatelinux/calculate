# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit linux-mod-r1

COMMIT="132dcf025806a436b9a95fb4af24eacfd07222f5"

DESCRIPTION="Realtek USB WiFi Adapters based on 8811CU/8821CU/8821CUH/8731AU Chipsets"
HOMEPAGE="https://github.com/morrownr/8821cu-20210916"
SRC_URI="https://github.com/morrownr/8821cu-20210916/archive/${COMMIT}.tar.gz -> rtl8821cu-${PV}.tar.gz"

S="${WORKDIR}/8821cu-20210916-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="virtual/linux-sources"

src_compile() {
	local modlist=( 8821cu=net/wireless )
	local modargs=( KSRC="${KV_OUT_DIR}" )

	linux-mod-r1_src_compile
}
