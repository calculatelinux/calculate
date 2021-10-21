# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"
PYTHON_COMPAT=(python3_9)

SRC_URI="ftp://ftp.calculate-linux.org/calculate/source/${PN}/${PF}.tar.bz2
	http://mirror.yandex.ru/calculate/source/${PN}/${PF}.tar.bz2"
DESCRIPTION="Collection of administration scripts for Calculate"
HOMEPAGE="http://www.calculate-linux.org"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=sys-apps/calculate-utils-3.6
	app-arch/zstd
	app-arch/xz-utils"

src_unpack() {
	unpack $A
}
