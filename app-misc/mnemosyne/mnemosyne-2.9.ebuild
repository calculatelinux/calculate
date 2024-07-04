# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{10..11} )
DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Efficient learning tool with powerful digital flash-cards"
HOMEPAGE="https://mnemosyne-proj.org/"

SRC_URI="https://github.com/mnemosyne-proj/mnemosyne/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

LICENSE="AGPL-3+ LGPL-3+"
SLOT="0"
IUSE="latex"

DEPEND="
	>=dev-python/PyQt5-5.6[gui,widgets,${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}
	dev-python/argon2-cffi[${PYTHON_USEDEP}]
	>=dev-python/cheroot-5.0.0[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP}]
	dev-python/pillow[${PYTHON_USEDEP}]
	dev-python/pyopengl[${PYTHON_USEDEP}]
	>=dev-python/PyQtWebEngine-5.6[${PYTHON_USEDEP}]
	>=dev-python/webob-1.4.0[${PYTHON_USEDEP}]
	latex? (
		app-text/dvipng
		virtual/latex-base
	)
"

distutils_enable_sphinx mnemosyne/libmnemosyne/docs
distutils_enable_tests nose

python_compile() {
	emake -C mnemosyne/pyqt_ui
	$(cd mnemosyne/pyqt_ui && \
		pyrcc5 -o mnemosyne_rc.py mnemosyne.qrc || die "pyrcc5 failed")
	emake -C po update && emake -C po
	esetup.py build "${@}"

	distutils_pep517_install "${BUILD_DIR}/install"
}

python_test() {
	emake -C po ../mo/de/LC_MESSAGES/mnemosyne.mo
	${EPYTHON} -m nose -v --exe tests || die "Tests fail with ${EPYTHON}"
}

pkg_postinst() {
	elog ""
	elog "The text-to-speech support would be disabled since gTTS is absent in Gentoo."
	elog ""
	elog "The Google translate support would be disabled since google_trans is absent in Gentoo."
	elog ""
}
