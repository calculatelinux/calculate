# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit distutils eutils

SRC_URI="ftp://ftp.calculate.ru/pub/calculate/calculate2/${PN}/${P}.tar.bz2"

DESCRIPTION="The utilities for assembling tasks of Calculate Linux"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate2"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="~sys-apps/calculate-builder-2.2.11
	~sys-apps/calculate-templates-2.2.11"

RDEPEND="${DEPEND}"

src_unpack() {
	unpack "${A}"
	cd "${S}"

	# fix bug in call listdir
	epatch "${FILESDIR}/calculate-assemble-2.2.11-fix_listdir.patch"

	# fix bug nvidia assembling
	epatch "${FILESDIR}/calculate-assemble-2.2.11-fix_nvidia_assembling.patch"
}
