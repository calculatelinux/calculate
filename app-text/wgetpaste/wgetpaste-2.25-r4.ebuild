# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-text/wgetpaste/wgetpaste-2.25-r3.ebuild,v 1.9 2014/11/02 09:09:38 ago Exp $

EAPI="8"

#inherit eutils

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="http://wgetpaste.zlin.dk/"
SRC_URI="http://wgetpaste.zlin.dk/${P}.tar.bz2"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="alpha amd64 ~arm hppa ia64 ~m68k ~mips ppc ppc64 ~s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"
IUSE=""

DEPEND=""
RDEPEND="net-misc/wget
	app-i18n/enca
"
PATCHES=( "${FILESDIR}"/calculate_wgetpaste-25.patch )
src_prepare() {
	default
	sed -i -e "s:/etc:\"${EPREFIX}\"/etc:g" wgetpaste || die
}

src_install() {
	dobin ${PN}
	insinto /etc/wgetpaste.d
	newins "${FILESDIR}"/wgetpaste-config-services services.conf
	insinto /usr/share/zsh/site-functions
	doins _wgetpaste
}
