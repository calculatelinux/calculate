# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit distutils eutils

SRC_URI="ftp://ftp.calculate.ru/pub/calculate/calculate2/${PN}/${P}.tar.bz2"

DESCRIPTION="The program of the desktop configuration Calculate Linux"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="kde xfce gnome"

DEPEND="~sys-apps/calculate-lib-2.2.28
	>=dev-python/python-ldap-2.0[ssl]
	xfce? ( x11-misc/xdialog )
	gnome? ( x11-misc/xdialog )
	kde? ( kde-base/kdialog )"

RDEPEND="${DEPEND}"

pkg_postinst() {
	#${EROOT}/usr/lib/calculate-2.2/calculate-desktop/bin/install
	einfo "For configure calculate-desktop perform:"
	einfo "  cl-desktop --install"
	if use kde || use xfce || use gnome
	then
		einfo "  /etc/init.d/xdm restart"
	fi
}

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# add mixer variables
	epatch "${FILESDIR}/calculate-desktop-2.2.28-mixer_vars.patch"

	# add bg color
	epatch "${FILESDIR}/calculate-desktop-2.2.28-bg_color.patch"
}
