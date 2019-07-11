# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils

<<<<<<< HEAD:www-plugins/firefox-ublock/firefox-ublock-1.20.3-r4.ebuild
MYPV="1.20.3rc4"
=======
MYPV="1.20.3rc3"
>>>>>>> 383076b351a8a63ec9c5bcf4b81c68c281b22aab:www-plugins/firefox-ublock/firefox-ublock-1.20.3-r3.ebuild

SRC_URI="https://github.com/gorhill/uBlock/releases/download/$MYPV/uBlock0_${MYPV}.firefox.signed.xpi"

DESCRIPTION="An efficient blocker for Firefox, beta version"
HOMEPAGE="https://github.com/gorhill/uBlock"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

DEPEND="|| ( www-client/firefox
	www-client/firefox-bin )"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_unpack() {
	cp ${DISTDIR}/uBlock0_${MYPV}.firefox.signed.xpi ${S}/uBlock0.firefox.signed.xpi
}

src_install() {
	dodir /usr/share/firefox-ublock
	insinto /usr/share/firefox-ublock
	doins -r *
}
