# Copyright 2007-2018 Mir Calculate
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Cryptodata management tools for Calculate"
HOMEPAGE="https://www.calculate-linux.org"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

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
	if use client
	then
		DESTDIR="$D" emake install_client
	fi

	if use server
	then
		DESTDIR="$D" emake install_server
	fi
}
