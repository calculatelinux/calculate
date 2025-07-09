# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit pam

DESCRIPTION="PAM Module of the waiting client daemon"
HOMEPAGE="https://www.calculate-linux.org/main/en/calculate2"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

DEPEND="net-nds/openldap"
RDEPEND="${DEPEND}"

src_compile() {
	make CFLAGS="-Wall ${CFLAGS}" || die
}

src_install() {
	dopammod pam_client.so
}
