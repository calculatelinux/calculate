# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Grub splashes for Calculate Linux"
HOMEPAGE="http://www.calculate-linux.org/packages/media-gfx/grub-splashes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="themes_CLD themes_CLDX themes_CLS themes_CLDG themes_CSS themes_CDS themes_CMC"

SRC_URI="
themes_CLD? (
	https://mirror.calculate-linux.org/themes/grub/grub-cld-13.tar.bz2
)
themes_CLDX? (
	https://mirror.calculate-linux.org/themes/grub/grub-cldx-13.tar.bz2
)
themes_CLDG? (
	https://mirror.calculate-linux.org/themes/grub/grub-cldg-13.tar.bz2
)
themes_CMC? (
	https://mirror.calculate-linux.org/themes/grub/grub-cmc-13.tar.bz2
)
themes_CLS? (
	https://mirror.calculate-linux.org/themes/grub/grub-cls-13.tar.bz2
)
themes_CDS? (
	https://mirror.calculate-linux.org/themes/grub/grub-cds-13.tar.bz2
)
themes_CSS? (
	https://mirror.calculate-linux.org/themes/grub/grub-css-13.tar.bz2
)"

REQUIRED_USE="^^ ( themes_CLD themes_CLDX themes_CLS themes_CLDG themes_CSS
themes_CDS themes_CMC )"

RDEPEND="!<sys-boot/calcboot-4.05.0-r1"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
}

