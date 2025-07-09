# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Bitwarden - The password manager (Chrome plugin)"
HOMEPAGE="https://bitwarden.com/ https://chrome.google.com/webstore/detail/nngceckbapebfimnlniiiahkandclblb"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/plyvel
	dev-python/sjcl"

src_install() {
	insinto /usr/share/${PN}
	doins -r * .*
	doins "${FILESDIR}"/configure.py
	fperms 755 /usr/share/$PN/configure.py
}
