# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Calculate Linux theme for gensplash"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/calculate-splash-themes"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+silent +silent-shutdown"

REQUIRED_USE="|| ( silent silent-shutdown )"

SRC_URI="silent? (
		https://mirror.calculate-linux.org/themes/calculate/splash-silent-${PV}.png -> ${PN}-silent-${PV}.png
	)
	silent-shutdown? (
		https://mirror.calculate-linux.org/themes/calculate/splash-shutdown-${PV}.jpg -> ${PN}-shutdown-${PV}.jpg
	)"

DEPEND="sys-boot/plymouth-calculate-plugin
	sys-boot/plymouth-openrc-plugin
	media-fonts/droid
	!<sys-apps/calculate-utils-3.5.4"

# need for templates
RDEPEND="${DEPEND}
	|| ( media-gfx/imagemagick
	media-gfx/graphicsmagick )"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/themes/Calculate/
	if use silent
	then
		newins "${DISTDIR}"/${PN}-silent-${PV}.png splash-silent.png
	fi
	if use silent-shutdown
	then
		newins "${DISTDIR}"/${PN}-shutdown-${PV}.jpg splash-shutdown.jpg
	fi
}
