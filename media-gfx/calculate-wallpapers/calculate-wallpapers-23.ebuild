# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Wallpapers for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/calculate-wallpapers"
SRC_URI="
	https://mirror.calculate-linux.org/themes/calculate/wallpaper-23.jpg -> ${PF}.jpg
	CL22? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-22.tar.bz2
	)
	CL21? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-21.tar.bz2
	)
	CL17? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-17.tar.bz2
	)
	CL15? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-15.tar.bz2
	)
	CL14? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-14-r1.tar.bz2
	)
	CL13? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-13.tar.bz2
	)
	CL12? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-12.tar.bz2
	)
	CL11? (
		https://mirror.calculate-linux.org/themes/wallpapers/wallpapers-11.tar.bz2
	)
	"

S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
VERSION_IUSE="CL11 CL12 CL13 CL14 CL15 CL17 CL21 CL22"
IUSE="+CL11 +CL12 +CL13 +CL14 +CL15 +CL17 +CL21 +CL22"

# need for templates
RDEPEND="${DEPEND}
	|| ( media-gfx/imagemagick
	media-gfx/graphicsmagick )"

src_install() {
	insinto /usr/share/themes/Calculate/
	newins "${DISTDIR}"/${PF}.jpg wallpaper.jpg

	insinto /
	for useflag in ${VERSION_IUSE}
	do
		if use $useflag
		then
			cd "$WORKDIR/calculate-wallpapers-${useflag//CL}"
			if [[ $useflag == CL22 ]]
			then
				mv usr/share/wallpapers/Calculate_Linux usr/share/wallpapers/Calculate_Linux_22
			fi
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
