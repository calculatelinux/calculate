# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )

DISTUTILS_USE_SETUPTOOLS=manual
inherit distutils2

DESCRIPTION="Python 3.4 Enum backported"
HOMEPAGE="https://pypi.org/project/enum34/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="doc"

DEPEND="dev-python/setuptools-python2[${PYTHON_USEDEP}]"

python_test() {
	"${PYTHON}" enum/test.py || die "Tests failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local DOCS=( enum/doc/. enum/README )

	distutils2_python_install_all
}
