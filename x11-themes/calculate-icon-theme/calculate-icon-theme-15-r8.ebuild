# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit xdg-utils

DESCRIPTION="Icons theme for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/x11-themes/calculate-icon-theme"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+qt5"

SRC_URI="https://mirror.calculate-linux.org/themes/icon/icon-calculate-15-r6.tar.bz2"

RDEPEND="|| (
		x11-themes/adwaita-icon-theme
		kde-plasma/breeze
		kde-frameworks/oxygen-icons
		x11-themes/elementary-icon-theme
		x11-themes/mate-icon-theme
	)
	qt5? ( dev-qt/qtsvg:5 )"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
