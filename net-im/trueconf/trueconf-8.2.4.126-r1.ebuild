# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker xdg

DESCRIPTION="Video conference client with a range of rich collaborative tools and an easy-to-use interface"
HOMEPAGE="https://trueconf.com/"
LICENSE="CC-BY-3.0"
SLOT="0"

KEYWORDS="~amd64"
IUSE="debug"
RESTRICT="bindist strip mirror"

SRC_URI="
	https://mirror.trueconf.ru/debian/pool/non-free/t/trueconf/${PN}_${PV}-deb11_i386.deb -> ${P}.deb
	https://trueconf.ru/download/client/linux/trueconf_client_debian11_amd64.deb?v=${PV} -> ${P}.deb
	https://mirror.yandex.ru/debian/pool/main/c/cppdb/libcppdb0_0.3.1%2Bdfsg-9%2Bb1_amd64.deb -> libcppdb0_0.3.1_amd64.deb
	https://mirror.yandex.ru/debian/pool/main/c/cppdb/libcppdb-sqlite3-0_0.3.1%2Bdfsg-9%2Bb1_amd64.deb \
		-> libcppdb-sqlite3-0_0.3.1_amd64.deb
	https://mirror.yandex.ru/debian/pool/main/i/icu/libicu67_67.1-7_amd64.deb
	https://mirror.yandex.ru/debian/pool/main/libi/libidn/libidn11_1.33-3_amd64.deb
	https://mirror.yandex.ru/debian/pool/main/p/protobuf/libprotobuf23_3.12.4-1+deb11u1_amd64.deb \
		-> libprotobuf23_3.12.4_amd64.deb
	https://mirror.yandex.ru/debian/pool/main/i/intel-mediasdk/libmfx1_22.5.4-1_amd64.deb
"
RDEPEND="
	>=sys-libs/glibc-2.11
	app-arch/bzip2
	app-text/ghostscript-gpl
	app-crypt/gnupg
	dev-libs/libatomic_ops
	dev-libs/glib
	dev-qt/qtcore
	dev-qt/qtdbus
	dev-qt/qtgui
	dev-qt/qtmultimedia
	dev-qt/qtnetwork
	dev-qt/qtopengl
	dev-qt/qtsensors
	dev-qt/qtsql
	dev-qt/qtsvg
	dev-qt/qtwebchannel[qml(+)]
	dev-qt/qtwidgets
	dev-qt/qtwebengine
	dev-qt/qtwebsockets[qml(+)]
	dev-qt/qtconcurrent
	dev-qt/qtgraphicaleffects
	dev-qt/qtimageformats
	dev-qt/qtquickcontrols
	dev-qt/qtquickcontrols2
	media-libs/speex
	media-libs/speexdsp
	media-libs/libv4l
	media-libs/libglvnd
	media-sound/alsa-utils
	media-plugins/alsa-plugins
	media-sound/lame
	media-sound/pulseaudio
	net-misc/curl
	sys-libs/zlib
	x11-libs/libXScrnSaver
	x11-libs/libX11
	x11-libs/libxcb
	x11-libs/libXext
	x11-libs/libXrandr
	virtual/libudev
"
QA_PREBUILT="*"
S=${WORKDIR}
TRUECONF="opt/${PN}"

src_unpack() {
	# При распаковке deb сразу всех происходит ошибка, распаковываем по отдельности
	unpack_deb ${P}.deb
	unpack_deb libcppdb0_0.3.1_amd64.deb
	unpack_deb libcppdb-sqlite3-0_0.3.1_amd64.deb
	unpack_deb libicu67_67.1-7_amd64.deb
	unpack_deb libidn11_1.33-3_amd64.deb
	unpack_deb libprotobuf23_3.12.4_amd64.deb
	unpack_deb libmfx1_22.5.4-1_amd64.deb
}

src_prepare() {
	# Перемещаем файлы библиотек в нужное место
	mv usr/lib/x86_64-linux-gnu/libcppdb* ${TRUECONF}/lib
	mv usr/lib/x86_64-linux-gnu/libicudata* ${TRUECONF}/lib
	mv usr/lib/x86_64-linux-gnu/libicui18n* ${TRUECONF}/lib
	mv usr/lib/x86_64-linux-gnu/libicuuc* ${TRUECONF}/lib
	mv lib/x86_64-linux-gnu/libidn* ${TRUECONF}/lib
	mv usr/lib/x86_64-linux-gnu/libprotobuf* ${TRUECONF}/lib
	mv usr/lib/x86_64-linux-gnu/libmfx.so.1* ${TRUECONF}/lib

	# Удалить лишнее от распаковки библиотек
	rm -r usr/share/doc || die
	rm -r usr/share/lintian || die
	rm -r usr/lib || die
	rm -r lib || die

	# Сделаем недостающую символьную ссылку на библиотеку
	pushd "${S}/${TRUECONF}/lib" > /dev/null || die
	ln -s -f "libcppdb.so.0" "libcppdb.so"
	popd > /dev/null || die

	default
}

src_install() {
	mv * "${D}" || die

	fperms a+x "${EPREFIX}/${TRUECONF}/${PN}"
	fperms a+x "${EPREFIX}/${TRUECONF}/${PN}-autostart"
}

pkg_postinst() {

	# Сделаем символьную ссылку на trueconf для быстрого запуска с консоли
	ln -s -f "/${TRUECONF}/trueconf" "/usr/bin/${PN}"

	# Сделаем символьную ссылку на системную библиотеку
	ln -s -f "/usr/lib64/libgs.so" "/${TRUECONF}/lib/libgs.so.9"

	binpid=$(ps axco pid,command | awk '$2 == "TrueConf" {print $1; }')
	if [ -n "$binpid" ]; then
	    for process in "$binpid"; do
	        kill -s 50 $process
	    done
	fi

	startupbin=$(ps axco pid,command | awk '$2 == "trueconf" {print $1; }')
	if [ -n "$startupbin" ]; then
	    for process in "$startupbin"; do
	        kill -s 50 $process
	    done
	fi

	xdg_desktop_database_update
}

pkg_postrm() {
	binpid=$(ps axco pid,command | awk '$2 == "TrueConf" {print $1; }')
	if [ -n "$binpid" ]; then
	    for process in "$binpid"; do
	        kill -s 50 $process
	    done
	fi

	startupbin=$(ps axco pid,command | awk '$2 == "trueconf" {print $1; }')
	if [ -n "$startupbin" ]; then
	    for process in "$startupbin"; do
	        kill -s 50 $process
	    done
	fi

	xdg_desktop_database_update
}
