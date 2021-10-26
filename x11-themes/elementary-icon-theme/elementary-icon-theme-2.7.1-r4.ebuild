# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit gnome2-utils

DESCRIPTION="Elementary icon theme is designed to be smooth, sexy, clear, and efficient"
HOMEPAGE="https://launchpad.net/elementaryicons"
SRC_URI="https://mirror.calculate-linux.org/themes/elementary/${PF}.tar.bz2
		http://mirror.yandex.ru/calculate/themes/elementary/${PF}.tar.bz2"

RESTRICT="binchecks strip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND=""
RDEPEND="${DEPEND}
		x11-themes/hicolor-icon-theme"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/icons
	doins -r elementary
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
