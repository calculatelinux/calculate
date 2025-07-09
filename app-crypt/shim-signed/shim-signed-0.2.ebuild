# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="UEFI Shim bootloader for SecureBoot signed by Microsoft"
HOMEPAGE="https://mjg59.dreamwidth.org/20303.html"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tgz"

S="${WORKDIR}"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64"

src_install() {
	insinto /usr/share
	doins -r "${PN}"
}

