# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_VERSION="${PV}-1"

DESCRIPTION="Epson scanner management utility"
HOMEPAGE="https://support.epson.net/linux/en/epsonscan2.php"
SRC_URI="https://support.epson.net/linux/src/scanner/${PN}/${PN}-${MY_VERSION}.src.tar.gz"
S="${WORKDIR}/${PN}-${MY_VERSION}"

inherit cmake desktop udev

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/boost
	dev-libs/rapidjson
	dev-qt/qtcore:5
	dev-qt/qtgui:5
	dev-qt/qtwidgets:5
	media-gfx/sane-backends
	media-libs/libharu
	media-libs/libjpeg-turbo:=
	media-libs/libpng
	media-libs/tiff
	sys-libs/zlib
	virtual/libusb:1
"
RDEPEND="${DEPEND}"

src_prepare() {
	cmake_src_prepare
	sed -i \
		-e '/\(execute_process.*\)${EPSON_INSTALL_ROOT}/d' \
		-e "s|^\(set(EPSON_VERSION \).*|\1-${PV})|g" \
		CMakeLists.txt || die
	# Force usage of system libraries
	rm -rf thirdparty/{HaruPDF,rapidjson,zlib}
	sed -i \
		-e '/thirdparty\/HaruPDF/d' \
		-e '/thirdparty\/zlib/d' \
		-e 's|^\([[:blank:]]*\)\(usb-1.0\)|\1\2\n\1hpdf\n\1z|' \
		src/Controller/CMakeLists.txt || die
}

src_install() {
	cmake_src_install
	# Sane symlinks
	dosym ../epsonscan2/libsane-epsonscan2.so /usr/$(get_libdir)/sane/libsane-epsonscan2.so.1
	dosym ../epsonscan2/libsane-epsonscan2.so /usr/$(get_libdir)/sane/libsane-epsonscan2.so.1.0.0
	# Desktop icon
	domenu desktop/rpm/x86_64/epsonscan2.desktop
}

pkg_postinst() {
	udev_reload
}

pkg_postrm() {
	udev_reload
}
