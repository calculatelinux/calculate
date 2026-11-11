# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Cryptodata management tools for Calculate"
HOMEPAGE="https://www.calculate-linux.org"
SRC_URI="https://git.calculate-linux.org/calculate/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"/${PN}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="+client server"
REQUIRED_USE="|| ( client server )"

RDEPEND="sys-apps/openrc
	net-misc/openssh
	client? ( sys-fs/cryptsetup )
	server? ( net-misc/rsync )"

src_install() {
	use client && emake DESTDIR="$D" install_client
	use server && emake DESTDIR="$D" install_server
}
