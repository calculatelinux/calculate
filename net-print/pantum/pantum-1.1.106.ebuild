# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CUPS and SANE drivers for Pantum series printer and scanner."
HOMEPAGE="https://www.pantum.ru/support/download/driver/"

IUSE="scanner"

MY_PV=${PV//./_}

SRC_URI="https://drivers.pantum.ru/userfiles/files/download/drive/2013/0619/Pantum%20Ubuntu%20Driver%20V${MY_PV}(1).zip"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror strip"

COMMON_DEPEND="
	>=sys-libs/glibc-2.0.0
	sys-apps/dbus
	media-libs/libjpeg8
	net-print/cups
	net-print/cups-filters
	virtual/jpeg:0
	scanner? (
		media-gfx/sane-backends
	)
"
BDEPEND="
	virtual/pkgconfig
"
DEPEND="
	${COMMON_DEPEND}
"
RDEPEND="
	${COMMON_DEPEND}
	app-text/ghostscript-gpl
"

S="${WORKDIR}/Pantum Ubuntu Driver V${PV}"

src_prepare() {
	eapply_user
	unpack "${S}/Resources/pantum_${PV}-1_amd64.deb" || die
}

src_install() {
	tar -xvf "${S}/data.tar.xz" -C "$D" || die
	if ! use scanner ; then
		rm -rf "${D}/usr/lib/x86_64-linux-gnu" || die
		rm -rf "${D}/usr/local" || die
	fi
	mv ${D}/usr/lib ${D}/usr/libexec || die
	mkdir -p "${D}/etc/ld.so.conf.d/" || die
	echo "/opt/pantum/lib" >> "${D}/etc/ld.so.conf.d/pantum.conf" || die
}

pkg_postinst() {
	mkdir -p /opt/pantum/lib || die
	ldconfig
}

pkg_prerm() {
	rm -rf /etc/ld.so.conf.d/pantum.conf
	ldconfig
}
