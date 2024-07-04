# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7
inherit pam

DESCRIPTION="System authentification update checkup tool"
HOMEPAGE="https://www.calculate-linux.org/main/en/calculate2"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
RDEPEND="${DEPEND} !<sys-apps/calculate-utils-3.5.0_alpha38"

src_compile() {
	make CFLAGS="-Wall ${CFLAGS}" || die
}

src_install() {
	dopammod pam_update.so
}
