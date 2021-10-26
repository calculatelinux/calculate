# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Grub splashes for Calculate Linux"
HOMEPAGE="http://www.calculate-linux.org/packages/media-gfx/grub-splashes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_URI="https://mirror.calculate-linux.org/themes/grub/grub-${PV}.tar.bz2
	http://mirror.yandex.ru/calculate/themes/grub/grub-${PV}.tar.bz2"
RDEPEND="!<sys-boot/calcboot-4.05.0-r1"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
}

