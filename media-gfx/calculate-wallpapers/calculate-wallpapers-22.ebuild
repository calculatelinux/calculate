# Copyritght 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Wallpapers for Calculate Linux"
HOMEPAGE="http://www.calculate-linux.org/packages/media-gfx/calculate-wallpapers"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
VERSION_IUSE="CL11 CL12 CL13 CL14 CL15 CL17 CL21"
IUSE="+CL11 +CL12 +CL13 +CL14 +CL15 +CL17 +CL21"

SRC_URI="
	https://mirror.calculate-linux.org/themes/calculate/wallpaper-22.jpg -> ${PF}.jpg
	https://mirror.yandex.ru/calculate/themes/calculate/wallpaper-22.jpg -> ${PF}.jpg
	CL21? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-21.tar.bz2
		https://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-21.tar.bz2
	)
	CL17? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-17.tar.bz2
		https://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-17.tar.bz2
	)
	CL15? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-15.tar.bz2
		https://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-15.tar.bz2
	)
	CL14? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-14-r1.tar.bz2
		https://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-14-r1.tar.bz2
	)
	CL13? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-13.tar.bz2
		https://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-13.tar.bz2
	)
	CL12? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-12.tar.bz2
		https://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-12.tar.bz2
	)
	CL11? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-11.tar.bz2
		https://mirror.yandex.ru/calculate/themes/wallpapers/wallpapers-11.tar.bz2
	)
	"

DEPEND="!<sys-apps/calculate-utils-3.5.2.6"

# need for templates
RDEPEND="${DEPEND}
	|| ( media-gfx/imagemagick
	media-gfx/graphicsmagick )"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/themes/Calculate/
	newins "${DISTDIR}"/${PF}.jpg wallpaper.jpg

	insinto /
	for useflag in $VERSION_IUSE
	do
		if use $useflag
		then
			cd $WORKDIR/calculate-wallpapers-${useflag//CL}
			if [[ $useflag == CL21 ]]
			then
				mv usr/share/wallpapers/Calculate_Linux usr/share/wallpapers/Calculate_Linux_21
			fi
			if [[ $useflag == CL17 ]]
			then
				mv usr/share/wallpapers/Calculate_Linux usr/share/wallpapers/Calculate_Linux_17
			fi
			if [[ $useflag == CL15 ]]
			then
				mv usr/share/wallpapers/Calculate_Linux usr/share/wallpapers/Calculate_Linux_15
			fi
			if [[ $useflag == CL14 ]]
			then
				mv usr/share/wallpapers/Calculate_Linux usr/share/wallpapers/Calculate_Linux_14
			fi
			doins -r usr
		fi
	done
}
