# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

DESCRIPTION="Lxdm theme for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/lxdm-themes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_URI="https://mirror.calculate-linux.org/themes/lxdm/lxdm-calculate-${PV}.tar.bz2"

RDEPEND="media-gfx/dm-themes-calculate"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
}
