# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="Free XO cyrillic fonts from MyOffice"
HOMEPAGE="https://myoffice.ru/products/fonts/"
SRC_URI="https://myoffice.ru/files/fonts/MyOffice_XO_Fonts_${PV}.zip"
S="${WORKDIR}"

LICENSE="open-xo-fonts"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="app-arch/unzip"

FONT_CONF=( "${FILESDIR}/60-xo-fonts.conf" )

src_install() {
	insinto /usr/share/fonts/${PN}

	local f
	for f in Caliburn Courser Oriel Tahion Thames ; do
		doins "XO_${f}/XO_${f}/TTF/"*.ttf
	done
	for f in Symbol SymbolM Trebizond Verbena Windy ; do
		doins "XO_${f}/"*.ttf
	done

	font_xfont_config
	font_fontconfig
}
