# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Wallpapers for Calculate Linux"
HOMEPAGE="http://www.calculate-linux.org/packages/media-gfx/calculate-wallpapers"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
VERSION_IUSE="CL11 CL12 CL13"
IUSE="+CL11 +CL12 +CL13"

SRC_URI="
	https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-14-r1.tar.bz2
	http://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-14-r1.tar.bz2
	CL11? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-11.tar.bz2
		http://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-11.tar.bz2
	)
	CL12? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-12.tar.bz2
		http://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-12.tar.bz2
	)
	CL13? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-13.tar.bz2
		http://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-13.tar.bz2
	)
	"

RDEPEND="!media-gfx/calculate-cldx-themes
		!media-gfx/calculate-cld-themes
		!media-gfx/cld-themes
		!media-gfx/cldx-themes"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .

	for useflag in $VERSION_IUSE
	do
		if use $useflag
		then
			cd $WORKDIR/calculate-wallpapers-${useflag//CL}
			doins -r usr
		fi
	done
}

