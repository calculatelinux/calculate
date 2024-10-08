# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pantum Printer Linux Driver"
HOMEPAGE="https://www.pantum.cn/support/download/driver/"
SRC_URI="https://drivers.pantum.com/userfiles/files/download/%E9%A9%B1%E5%8A%A8%E6%96%87%E4%BB%B6/Pantum%20Linux%20Driver%20V1_1_94-1.zip"

S="${WORKDIR}/Pantum Linux Driver V1.1.94-1"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="amd64"

IUSE="scanner"

COMMON_DEPEND="
	media-libs/libjpeg-turbo
	media-libs/libjpeg8
	net-print/cups
	net-print/cups-filters
	sys-apps/dbus
	scanner? (
		media-gfx/sane-backends
	)
"
BDEPEND="
	app-arch/unzip
	virtual/pkgconfig
"
DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
	app-text/ghostscript-gpl
"
src_prepare(){
	eapply_user
	unpack "${S}/Resources/pantum_1.1.94-1_amd64.deb"
}

src_install(){
	tar -xvf "${S}/data.tar.xz" -C "$D"
	if ! use scanner ; then
		rm -rf "${D}/usr/lib/x86_64-linux-gnu"
		rm -rf "${D}/usr/local"
	fi
	mv "${D}"/usr/lib "${D}"/usr/libexec
	mkdir "${D}/etc/ld.so.conf.d/"
	echo /opt/pantum/lib >> "${D}/etc/ld.so.conf.d/pantum.conf"
}

post_install(){
	ldconfig
}
