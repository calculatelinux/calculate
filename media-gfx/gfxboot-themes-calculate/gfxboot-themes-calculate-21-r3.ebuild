# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Gfxboot themes for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/gfxboot-themes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

SRC_URI="https://mirror.calculate-linux.org/themes/gfxboot/gfxboot-themes-calculate-${PVR}.tar.bz2"

DEPEND="media-gfx/gfxboot
	!<sys-apps/calculate-utils-3.5.2.6"

RDEPEND="${DEPEND}"

S="${WORKDIR}/gfxboot-themes-calculate-21-r3"

src_compile() {
	emake -j1
}

src_install() {
	dodir /usr/share/themes/gfxboot-themes-calculate
	insinto /usr/share/themes/gfxboot-themes-calculate
	doins -r $(find install/* | grep -v -e back.jpg -e install/log -e bootlogo.tar.gz)
	insinto /usr/share/themes/Calculate
	newins back.jpg gfxboot.jpg
}
