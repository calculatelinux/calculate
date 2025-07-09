# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sync your bookmarks privately across browsers and devices (Chrome plugin)"
HOMEPAGE="https://floccus.org/ https://chrome.google.com/webstore/detail/fnaicdffflnofjppbagibeoednhnbjhg"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

S="${WORKDIR}"

LICENSE="MPL-2.0"
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
