# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

COMMIT="31a6f80784d289d2faa8c4ca4788409c83b3ea14"

DESCRIPTION="EDID binary files"
HOMEPAGE="https://github.com/akatrevorjay/edid-generator"
SRC_URI="https://github.com/akatrevorjay/edid-generator/archive/${COMMIT}.tar.gz -> edid-data-${PV}.tar.gz"
SLOT="0"

LICENSE="GPL-2"
KEYWORDS="amd64"

DEPEND=""
RDEPEND=""

S="${WORKDIR}/edid-generator-${COMMIT}"

src_compile() {
	:
}

src_install() {
	dodir /usr/share/edid
	insinto /usr/share/edid
	doins *.bin
}
