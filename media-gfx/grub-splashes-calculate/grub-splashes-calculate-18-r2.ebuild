# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Grub splashes for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/grub-splashes-calculate"
SRC_URI="https://mirror.calculate-linux.org/themes/calculate/grub-18-r1.jpg -> ${PF}.jpg"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="!<sys-apps/calculate-utils-3.5.2.6"

# need for templates
RDEPEND="${DEPEND}
	|| ( media-gfx/imagemagick
	media-gfx/graphicsmagick )"

src_install() {
	insinto /usr/share/themes/Calculate/
	newins "${DISTDIR}"/${PF}.jpg grub.jpg
}
