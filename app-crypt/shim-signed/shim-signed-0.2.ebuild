# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="UEFI Shim bootloader for SecureBoot signed by Microsoft"
HOMEPAGE="http://mjg59.dreamwidth.org/20303.html"
SRC_URI="http://www.codon.org.uk/~mjg59/${PN}/${P}.tgz"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tgz"

LICENSE="as-is"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND=""

S="${WORKDIR}"

src_install() {
	insinto /usr/share
	doins -r $PN
}

