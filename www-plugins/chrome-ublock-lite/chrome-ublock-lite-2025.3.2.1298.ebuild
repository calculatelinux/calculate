# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Free, open-source permission-less ad content blocker (Chrome plugin)"
HOMEPAGE="https://chromewebstore.google.com/detail/ublock-origin-lite/ddkjiahejlhfcafbddmgiahcphecmpfh"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/plyvel"

src_install() {
	insinto /usr/share/chrome-ublock-lite
	doins -r *
	doins "${FILESDIR}"/configure.py
	fperms 755 /usr/share/chrome-ublock-lite/configure.py
}
