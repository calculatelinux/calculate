# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

DISTUTILS_USE_SETUPTOOLS=manual
inherit distutils2

DESCRIPTION="Lightweight SOAP client - Czech NIC labs fork"
HOMEPAGE="https://labs.nic.cz/page/969/"
SRC_URI="ftp://ftp.calculate-linux.org/calculate/source/${PN}/${P}.tar.gz
		http://mirror.yandex.ru/calculate/source/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

DEPEND="dev-python/setuptools-python2[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"
