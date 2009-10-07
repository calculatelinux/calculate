# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit kde eutils

MY_P="translatoid"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Translator using google translator"
HOMEPAGE="http://kde-look.org/content/show.php/translatoid?content=97511"
SRC_URI="http://ktank.free.fr/plasmoid/translatoid.0.9.tar.gz"
LICENSE="GPL-2"

SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

DEPEND="
	>=kde-base/kdelibs-4.2.0
	>=dev-util/cmake-2.4"

src_compile() {
	cmake -DCMAKE_INSTALL_PREFIX=/usr/ || die "cmake failed"
	emake || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
