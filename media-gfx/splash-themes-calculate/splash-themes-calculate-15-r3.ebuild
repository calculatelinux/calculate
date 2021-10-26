# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit calculate

DESCRIPTION="Calculate Linux theme for gensplash"
HOMEPAGE="http://www.calculate-linux.org/packages/media-gfx/calculate-splash-themes"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

SRC_URI="https://mirror.calculate-linux.org/themes/splash/splash-themes-calculate-15-r2.tar.bz2"

RDEPEND="media-gfx/splashutils
media-fonts/droid
!media-gfx/cld-themes
!media-gfx/cldg-themes
!media-gfx/cldx-themes
!media-gfx/cls-themes
!media-gfx/cmc-themes
!media-gfx/cds-themes"

DEPEND="${RDEPEND}"

src_install() {
	insinto /
	doins -r .
}
