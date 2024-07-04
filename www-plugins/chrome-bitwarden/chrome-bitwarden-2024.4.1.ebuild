# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

DESCRIPTION="Bitwarden - The password manager"
HOMEPAGE="https://chrome.google.com/webstore/detail/nngceckbapebfimnlniiiahkandclblb"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/plyvel
	dev-python/sjcl"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/${PN}
	doins -r *
	doins "${FILESDIR}"/configure.py
	fperms 755 /usr/share/$PN/configure.py
}
