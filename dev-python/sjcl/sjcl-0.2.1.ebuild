# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( pypy3 python3_{9..12} )

inherit distutils-r1 pypi

DESCRIPTION="Decrypt and encrypt messages compatible to the SJCL message format"
HOMEPAGE="https://github.com/berlincode/sjcl"
SRC_URI="$(pypi_sdist_url --no-normalize ${PN} ${PV})"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="dev-python/pycryptodome"
DEPEND="${RDEPEND}"

src_prepare() {
	distutils-r1_python_prepare_all
	sed -e "s:description-:description_:" -i setup.cfg
}
