# Copyright 2007-2024 Mir Calculate
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Runs other programs with the user password, kept in the Linux kernel"
HOMEPAGE="https://www.calculate-linux.org/main/en/keyexec"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
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
