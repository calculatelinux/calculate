# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

inherit eutils

SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2
	http://mirror.yandex.ru/calculate/${PN}/${P}.tar.bz2"

DESCRIPTION="An efficient blocker for Chromium"
HOMEPAGE="https://chrome.google.com/webstore/detail/cjpalhdlnbpafiamejdnhcphjbkeiagm"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/plyvel"

S="${WORKDIR}"

src_install() {
	dodir /usr/share/chrome-ublock
	insinto /usr/share/chrome-ublock
	doins -r *
	doins ${FILESDIR}/configure.py
	fperms 755 /usr/share/chrome-ublock/configure.py
}
