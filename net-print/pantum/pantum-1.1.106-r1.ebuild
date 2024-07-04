# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="CUPS and SANE drivers for Pantum series printer and scanner."
HOMEPAGE="https://www.pantum.ru/support/download/driver/"

inherit udev

IUSE="scanner"

MY_PV=${PV//./_}

SRC_URI="https://drivers.pantum.ru/userfiles/files/download/drive/2013/0619/Pantum%20Ubuntu%20Driver%20V${MY_PV}(1).zip"

LICENSE="AS-IS"
SLOT="0"
KEYWORDS="amd64"
RESTRICT="bindist mirror strip"

COMMON_DEPEND="
	media-libs/libjpeg8
	net-print/cups
	net-print/cups-filters
	sys-apps/dbus
	sys-libs/glibc
	sys-libs/libcap
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

S="${WORKDIR}/Pantum Ubuntu Driver V${PV}"

src_prepare() {
	eapply_user
	unpack "${S}/Resources/pantum_${PV}-1_amd64.deb" || die
	tar -xvf "${S}/data.tar.xz" || die
}

src_install() {
	insinto /etc/sane.d
	doins etc/sane.d/*
	insinto "/usr/$(get_libdir)/sane"
	doins usr/lib/x86_64-linux-gnu/sane/libsane-pantum*.so*
	udev_dorules etc/udev/rules.d/*.rules

	exeinto /opt/pantum/bin
	doexe opt/pantum/bin/ptqpdf
	exeinto /usr/libexec/cups/filter
	doexe usr/lib/cups/filter/*
	insinto /usr/share/cups/model
	doins -r usr/share/cups/model/Pantum

#	if ! use scanner ; then
#		rm -rf "${D}/usr/lib/x86_64-linux-gnu" || die
#		rm -rf "${D}/usr/local" || die
#	fi
#	mv ${D}/usr/lib ${D}/usr/libexec || die
#	mkdir -p "${D}/etc/ld.so.conf.d/" || die
#	echo "/opt/pantum/lib" >> "${D}/etc/ld.so.conf.d/pantum.conf" || die
}

pkg_postrm() {
	udev_reload
}

pkg_postinst() {
#	mkdir -p /opt/pantum/lib || die
#	ldconfig
	udev_reload
}

#pkg_prerm() {
#	rm -rf /etc/ld.so.conf.d/pantum.conf
#	ldconfig
#}
