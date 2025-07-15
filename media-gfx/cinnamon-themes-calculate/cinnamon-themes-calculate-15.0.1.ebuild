# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

DESCRIPTION="Cinnamon theme for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/cinnamon-themes-calculate"
SRC_URI="https://mirror.calculate-linux.org/themes/cinnamon/cinnamon-calculate-${PV}.tar.bz2"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

src_install() {
	insinto /
	doins -r .
}
