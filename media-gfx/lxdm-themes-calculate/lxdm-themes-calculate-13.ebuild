# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

DESCRIPTION="Lxdm theme for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/lxdm-themes-calculate"
SRC_URI="https://mirror.calculate-linux.org/themes/lxdm/lxdm-calculate-${PV}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="media-gfx/dm-themes-calculate"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
}
