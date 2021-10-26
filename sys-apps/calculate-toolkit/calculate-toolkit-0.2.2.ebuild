# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Collection of administration scripts for Calculate"
HOMEPAGE="http://www.calculate-linux.org"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2
	http://mirror.yandex.ru/calculate/source/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="x86 amd64"

RDEPEND=">=sys-apps/calculate-utils-3.5.8.12
	app-arch/xz-utils"

src_unpack() {
	unpack $A
}
