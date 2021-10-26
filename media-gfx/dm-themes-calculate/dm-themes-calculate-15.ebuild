# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Wallpapers for Calculate Linux"
HOMEPAGE="http://www.calculate-linux.org/packages/media-gfx/dm-themes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_URI="https://mirror.calculate-linux.org/themes/dm/dm-15.tar.bz2
	http://mirror.yandex.ru/calculate/themes/dm/dm-15.tar.bz2"

RDEPEND=""

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
}

