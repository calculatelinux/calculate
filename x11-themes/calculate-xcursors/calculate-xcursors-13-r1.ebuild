# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

DESCRIPTION="Calculate X.Org mouse cursor"
HOMEPAGE="http://www.calculate-linux.org/packages/x11-themes/calculate-xcursors"

SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2
	http://mirror.yandex.ru/calculate/source/${PN}/${P}.tar.bz2"

KEYWORDS="amd64 x86"
IUSE=""
SLOT="0"

RDEPEND="!media-gfx/cld-themes
!media-gfx/cldg-themes
!media-gfx/cldx-themes
!media-gfx/cls-themes"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
	dosym ../neutral/cursors /usr/share/cursors/xorg-x11/calculate/cursors
	dosym ../neutral/source /usr/share/cursors/xorg-x11/calculate/source
}
