# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8
DESCRIPTION="Iconset Papirus for Claws Mail"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/papirus-claws-mail-theme"
COMMIT="7d02981d23ecfc279c87ff6c172ba09314940352"
SRC_URI="https://github.com/PapirusDevelopmentTeam/papirus-claws-mail-theme/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/papirus-claws-mail-theme-${COMMIT}"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="!>=x11-themes/claws-mail-themes-20221017"
RDEPEND="mail-client/claws-mail ${DEPEND}"

src_install() {
	insinto /usr/share/claws-mail/themes
	doins -r Papirus
}
