# Copyright 2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="XFCE theme for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/xfce-themes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_URI="https://mirror.calculate-linux.org/themes/xfce/${PF}.tar.bz2"

src_install() {
	insinto /
	doins -r .
}
