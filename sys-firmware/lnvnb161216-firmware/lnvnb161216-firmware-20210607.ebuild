# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

MYPN=linux-firmware
MYP=linux-firmware-${PV}

KEYWORDS="amd64 x86"

SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2
	http://mirror.yandex.ru/calculate/source/${PN}/${P}.tar.bz2"
DESCRIPTION="Binary firmware for Lenovo Yoga 7 (LNVNB161216) S3 mode"
HOMEPAGE="https://gist.github.com/zurohki/4b859668c901e6ba13e8187a0d5d734c"

LICENSE="linux-firmware ( BSD ISC MIT no-source-code ) GPL-2 GPL-2+ freedist"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND=""

RESTRICT="binchecks strip"

S="${WORKDIR}"

src_install() {
	insinto /lib/firmware/
	doins -r acpi
}
