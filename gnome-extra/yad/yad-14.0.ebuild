# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnome2

DESCRIPTION="Display GTK+ dialog boxes from command line or shell scripts"
HOMEPAGE="https://github.com/v1cont/yad"
SRC_URI="https://github.com/v1cont/${PN}/releases/download/v${PV}/${P}.tar.xz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="nls spell webkit"

RDEPEND="
	>=x11-libs/gtk+-3.22.0:3=
	spell? ( app-text/gspell:0 )
	webkit? (
		|| ( net-libs/webkit-gtk:4.1 net-libs/webkit-gtk:4 )
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	>=dev-util/intltool-0.40.0
"

src_configure() {
	gnome2_src_configure \
		$(use_enable nls) \
		$(use_enable spell) \
		$(use_enable webkit html) \
		--disable-sourceview \
		--disable-standalone \
		--enable-tools \
		--enable-icon-browser \
		--enable-tools \
		--enable-tray
}
