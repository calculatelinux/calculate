# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

DESCRIPTION="Display manager wallpapers for Calculate Linux"
HOMEPAGE="https://www.calculate-linux.org/packages/media-gfx/dm-themes-calculate"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+splash +login"

REQUIRED_USE="|| ( splash login )"

SRC_URI="login? (
		https://mirror.calculate-linux.org/themes/calculate/dm-login-${PV}.jpg -> ${PN}-login-${PVR}.jpg
	)
	splash? (
		https://mirror.calculate-linux.org/themes/calculate/dm-splash-${PV}.jpg -> ${PN}-splash-${PVR}.jpg
	)"

DEPEND="!<sys-apps/calculate-utils-3.5.2.6"

# need for templates
RDEPEND="${DEPEND}
	|| ( media-gfx/imagemagick
	media-gfx/graphicsmagick )"

S="${WORKDIR}"

src_install() {
	insinto /usr/share/themes/Calculate/
	use login && newins "${DISTDIR}"/${PN}-login-${PVR}.jpg dm-login.jpg
	use splash && newins "${DISTDIR}"/${PN}-splash-${PVR}.jpg dm-splash.jpg
}
