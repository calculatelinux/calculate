# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Cinnamon theme for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/cinnamon-themes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_URI="https://mirror.calculate-linux.org/themes/cinnamon/cinnamon-calculate-${PV}.tar.bz2"

REQUIRED_USE=""

S="${WORKDIR}"

src_install() {
	insinto /
	doins -r .
}
