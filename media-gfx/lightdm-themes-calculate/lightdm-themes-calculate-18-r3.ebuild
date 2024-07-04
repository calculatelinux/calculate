# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Lightdm themes for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/lightdm-themes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_URI="https://mirror.calculate-linux.org/themes/lightdm/lightdm-calculate-${PVR}.tar.bz2"

RDEPEND="x11-themes/gtk-engines-murrine
	x11-misc/lightdm-gtk-greeter"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
}
