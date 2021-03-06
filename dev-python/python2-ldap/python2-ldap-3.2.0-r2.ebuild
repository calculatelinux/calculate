# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 )

DISTUTILS_USE_SETUPTOOLS=manual
inherit distutils2

MY_PN=python-ldap
MY_P=$MY_PN-$PV

DESCRIPTION="Various LDAP-related Python modules"
HOMEPAGE="https://www.python-ldap.org/en/latest/
	https://pypi.org/project/python-ldap/
	https://github.com/python-ldap/python-ldap"
if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/python-ldap/python-ldap.git"
	inherit git-r3
else
	SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ppc ppc64 sparc x86 ~x86-solaris"
fi

LICENSE="PSF-2"
SLOT="0"
IUSE="examples sasl ssl"

# We do not need OpenSSL, it is never directly used:
# https://github.com/python-ldap/python-ldap/issues/224
RDEPEND="
	!dev-python/pyldap
	!dev-python/python-ldap[python_targets_python2_7]
	>=dev-python/pyasn1-python2-0.3.7[${PYTHON_USEDEP}]
	>=dev-python/pyasn1-modules-python2-0.1.5[${PYTHON_USEDEP}]
	>net-nds/openldap-2.4.11:=[sasl?,ssl?]
"
# We do not link against cyrus-sasl but we use some
# of its headers during the build.
BDEPEND="
	dev-python/setuptools-python2[${PYTHON_USEDEP}]
	>net-nds/openldap-2.4.11:=[sasl?,ssl?]
	sasl? ( >=dev-libs/cyrus-sasl-2.1 )
"

S="${WORKDIR}/${MY_PN}-${PV}"
RESTRICT="test"

python_prepare_all() {
	# The live ebuild won't compile if setuptools_scm < 1.16.2 is installed
	# https://github.com/pypa/setuptools_scm/issues/228
	if [[ ${PV} == *9999* ]]; then
		rm -r .git || die
	fi

	if ! use sasl; then
		sed -i 's/HAVE_SASL//g' setup.cfg || die
	fi
	if ! use ssl; then
		sed -i 's/HAVE_TLS//g' setup.cfg || die
	fi

	distutils2_python_prepare_all
}

python_install() {
	distutils2_python_install
	python_optimize
}

python_install_all() {
	distutils2_python_install_all
	rm -r ${D}/usr/share
}
