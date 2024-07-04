# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8
DESCRIPTION="Runs other programs with the user password, kept in the Linux kernel"
HOMEPAGE="https://www.calculate-linux.org/main/en/keyexec"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"

SLOT="0"

KEYWORDS="amd64 x86"

IUSE="kde +rdesktop +freerdp"

DEPEND="
	rdesktop? ( net-misc/rdesktop )
	freerdp? ( net-misc/freerdp )
	>=sys-apps/keyutils-1.1
	>=sys-auth/pam_keystore-0.1
	kde? ( kde-plasma/kde-cli-tools:5 )"

RDEPEND="${DEPEND}"

src_compile() {
	emake CFLAGS="-Wall ${CFLAGS}" || die
}

src_install() {
	emake install DESTDIR="${D}"
}
