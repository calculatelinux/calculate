# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Free, open-source ad content blocker (Chrome plugin)"
HOMEPAGE="https://ublockorigin.com https://chrome.google.com/webstore/detail/cjpalhdlnbpafiamejdnhcphjbkeiagm"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

S="${WORKDIR}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/plyvel"

src_install() {
	insinto /usr/share/chrome-ublock
	doins -r * .*
	doins "${FILESDIR}"/configure.py
	fperms 755 /usr/share/chrome-ublock/configure.py
}
