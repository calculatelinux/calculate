# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit xdg-utils

DESCRIPTION="Elementary icon theme is designed to be smooth, sexy, clear, and efficient"
HOMEPAGE="https://launchpad.net/elementaryicons"
SRC_URI="https://mirror.calculate-linux.org/themes/elementary/${PF}.tar.bz2"

RESTRICT="binchecks strip"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	x11-themes/hicolor-icon-theme
"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/icons
	doins -r elementary
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
