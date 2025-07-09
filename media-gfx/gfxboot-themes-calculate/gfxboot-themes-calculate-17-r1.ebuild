# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Gfxboot themes for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/gfxboot-themes-calculate"
SRC_URI="https://mirror.calculate-linux.org/themes/gfxboot/gfxboot-themes-calculate-${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="media-gfx/gfxboot
	!<sys-apps/calculate-utils-3.5.2.6"

RDEPEND="${DEPEND}"

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
