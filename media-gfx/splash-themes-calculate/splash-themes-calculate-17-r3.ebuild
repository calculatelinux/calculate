# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Calculate Linux theme for gensplash"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/calculate-splash-themes"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+verbose +silent +silent-shutdown"

REQUIRED_USE="|| ( verbose silent silent-shutdown )"

SRC_URI="silent? (
		https://mirror.calculate-linux.org/themes/calculate/splash-silent-17.jpg -> ${PN}-silent-17.jpg
	verbose? (
		https://mirror.calculate-linux.org/themes/calculate/splash-verbose-17-r1.jpg -> ${PN}-verbose-17-r1.jpg
	silent-shutdown? (
		https://mirror.calculate-linux.org/themes/calculate/splash-shutdown-17.jpg -> ${PN}-shutdown-17.jpg
	)"

DEPEND="media-gfx/splashutils
	media-fonts/droid
	!<sys-apps/calculate-utils-3.5.2.6"

# need for templates
RDEPEND="${DEPEND}
	|| ( media-gfx/imagemagick
	media-gfx/graphicsmagick )"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/themes/Calculate/
	if use silent
	then
		newins "${DISTDIR}"/${PN}-silent-${PV}.jpg splash-silent.jpg
	fi
	if use silent-shutdown
	then
		newins "${DISTDIR}"/${PN}-shutdown-${PV}.jpg splash-shutdown.jpg
	fi
	if use verbose
	then
		newins "${DISTDIR}"/${PN}-verbose-${PV}-r1.jpg splash-verbose.jpg
	fi
}
