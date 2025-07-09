# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson xdg-utils

DESCRIPTION="Named, vector icons for elementary OS"
HOMEPAGE="https://github.com/elementary/icons"
SRC_URI="https://github.com/elementary/icons/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/icons-${PV}"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

RESTRICT="binchecks strip"

BDEPEND="
	gnome-base/librsvg
	x11-apps/xcursorgen
	sys-devel/gettext
	virtual/pkgconfig
"
RDEPEND="
	x11-themes/hicolor-icon-theme
"

DOCS=( README.md COPYING CONTRIBUTING.md )

src_configure() {
	local emesonargs=(
		# https://github.com/elementary/icons/issues/701
		-Dvolume_icons=false
	)
	meson_src_configure
}

src_install() {
	# https://github.com/elementary/icons/pull/1177
	find . -type f -name '*.svg' -exec chmod -x "{}" ";"
	meson_src_install
}

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
