# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTE: This is a version of `app-text/wgetpaste-2.33-r5::gentoo` with additional services

EAPI=8

inherit optfeature

DESCRIPTION="Command-line interface to various pastebins"
HOMEPAGE="https://github.com/zlin/wgetpaste"
SRC_URI="https://github.com/zlin/wgetpaste/releases/download/${PV}/${P}.tar.xz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="+ssl"

PROPERTIES="test_network"
RESTRICT="test"

RDEPEND="net-misc/wget[ssl?]"

PATCHES=(
	"${FILESDIR}"/${PN}-2.33-tests.patch
	"${FILESDIR}"/${PN}-2.33-disable-sprunge.patch
	"${FILESDIR}"/${PN}-2.33-add-paste-gentoo-zip.patch
	"${FILESDIR}"/${PN}-2.33-change-arg-parsing-priority.patch
	"${FILESDIR}"/${PN}-2.33-add-A-ansi.patch
	"${FILESDIR}"/${PN}-2.33-test_ansi-add-A-to-the-tests.patch
	"${FILESDIR}"/${PN}-2.33-added-quiet-flag.patch
	"${FILESDIR}"/${PN}-2.33-add-paste-calculate.patch
	"${FILESDIR}"/${PN}-2.33-add-paste-orgru.patch
)

src_prepare() {
	default

	sed -i -e "s:/etc:\"${EPREFIX}\"/etc:g" wgetpaste || die
}

src_test() {
	test/test.sh || die
}

src_install() {
	dobin ${PN}
	insinto /usr/share/zsh/site-functions
	doins _wgetpaste
	insinto /etc/wgetpaste.d
	newins "${FILESDIR}"/wgetpaste-config-services services.conf
}

pkg_postinst() {
	optfeature "ANSI (color code) stripping support" app-text/ansifilter
	optfeature "xclip support" x11-misc/xclip
}
