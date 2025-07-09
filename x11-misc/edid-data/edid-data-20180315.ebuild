# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

COMMIT="31a6f80784d289d2faa8c4ca4788409c83b3ea14"

DESCRIPTION="EDID binary files"
HOMEPAGE="https://github.com/akatrevorjay/edid-generator"
SRC_URI="https://github.com/akatrevorjay/edid-generator/archive/${COMMIT}.tar.gz -> edid-data-${PV}.tar.gz"

S="${WORKDIR}/edid-generator-${COMMIT}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"

src_compile() {
	:
}

src_install() {
	insinto /usr/share/edid
	dodir /usr/share/edid
	doins *.bin
}
