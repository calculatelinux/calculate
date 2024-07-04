# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

DESCRIPTION="Cryptodata management tools"
HOMEPAGE="https://www.calculate-linux.org/main/en/calculate_access"
SRC_URI="https://mirror.calculate-linux.org/source/${PN}/${P}.tar.bz2"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+client server"
REQUIRED_USE="|| ( client server )"
RDEPEND="sys-apps/openrc
	net-misc/openssh
	client? ( sys-fs/cryptsetup )
	server? ( net-misc/rsync )"

src_install() {
	if use client
	then
		DESTDIR=$D emake install_client
	fi

	if use server
	then
		DESTDIR=$D emake install_server
	fi
}
