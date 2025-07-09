# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Tool to test and create graphical boot logos"
HOMEPAGE="https://launchpad.net/ubuntu/precise/+source/gfxboot-themes"
SRC_URI="https://launchpad.net/ubuntu/+archive/primary/+sourcefiles/gfxboot/${PV}-1/${PN}_${PV}.orig.tar.gz"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS="amd64"

DEPEND="app-arch/cpio
	app-text/docbook-xml-dtd:4.1.2
	app-text/xmlto
	dev-lang/nasm
	dev-libs/libxslt
	dev-perl/HTML-Parser
	>=media-libs/freetype-2"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}/gfxboot-fix_warning.patch"
	"${FILESDIR}/gfxboot-fix_bigsize.patch"
)

src_install() {
	emake DESTDIR="${D}" THEMES="" install
}
