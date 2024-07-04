# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

inherit git-r3

DESCRIPTION="Cryptodata management tools"
HOMEPAGE="https://www.calculate-linux.org/main/en/calculate_access"
SRC_URI=""
EGIT_REPO_URI="git://git.calculate-linux.org/calculate-access.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE="+client server"
REQUIRED_USE="|| ( client server )"

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
