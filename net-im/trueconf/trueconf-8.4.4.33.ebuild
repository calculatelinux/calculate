# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit unpacker xdg

DESCRIPTION="TrueConf for Linux is a video conferencing app with advanced collaboration tools and user-friendly UI"
HOMEPAGE="https://www.trueconf.com/"
LICENSE="CC-BY-3.0"
SLOT="0"

KEYWORDS="~amd64"
IUSE="debug"
RESTRICT="bindist strip mirror"

SRC_URI="
	https://mirror.trueconf.ru/debian/pool/non-free/t/trueconf/${PN}_${PV}-deb12_amd64.deb -> ${P}.deb
	https://mirror.yandex.ru/debian/pool/main/c/cppdb/libcppdb0_0.3.1%2Bdfsg-9%2Bb1_amd64.deb -> libcppdb0_0.3.1_${PVR}.deb
	https://mirror.yandex.ru/debian/pool/main/c/cppdb/libcppdb-sqlite3-0_0.3.1%2Bdfsg-9%2Bb1_amd64.deb \
		-> libcppdb-sqlite3-0_0.3.1_${PVR}.deb
	https://mirror.yandex.ru/debian/pool/main/p/protobuf/libprotobuf32t64_3.21.12-10+b2_amd64.deb \
		-> libprotobuf32t64_3.21.12_${PVR}.deb
	https://mirror.yandex.ru/debian/pool/main/i/intel-mediasdk/libmfx1_22.5.4-1_amd64.deb -> libmfx1_22.5.4_${PVR}.deb
	http://ftp.ru.debian.org/debian/pool/main/i/icu/libicu72_72.1-6_amd64.deb -> libicu72_72.1_${PVR}.deb
	http://ftp.ru.debian.org/debian/pool/main/c/curl/libcurl4_7.88.1-10%2Bdeb12u8_amd64.deb -> libcurl4_7.88.1_${PVR}.deb
	https://mirror.yandex.ru/debian/pool/main/o/openldap/libldap-2.5-0_2.5.19%2Bdfsg-1_amd64.deb -> libldap-2.5_${PVR}.deb
	http://ftp.ru.debian.org/debian/pool/main/b/boost1.74/libboost-filesystem1.74.0_1.74.0%2Bds1-21_amd64.deb -> libboost-filesystem1.74.0_${PVR}.deb
	http://ftp.ru.debian.org/debian/pool/main/b/boost1.74/libboost-regex1.74.0_1.74.0+ds1-21_amd64.deb -> libboost-regex1.74.0_${PVR}.deb
	http://ftp.ru.debian.org/debian/pool/main/c/cyrus-sasl2/libsasl2-2_2.1.28%2Bdfsg1-8_amd64.deb -> libsasl2-2_2.1.28_${PVR}.deb
"

RDEPEND="
	>=sys-libs/glibc-2.11
	app-arch/bzip2
	app-text/ghostscript-gpl
	app-crypt/gnupg
	app-crypt/mit-krb5
	dev-db/sqlite:3
	dev-libs/boost
	dev-libs/double-conversion
	dev-libs/libphonenumber
	dev-qt/qtxml:5
	dev-qt/qtdeclarative:5
	dev-qt/qtstyleplugins:5
	dev-libs/glib
	dev-qt/qtsvg:5
	dev-qt/qtwebchannel:5[qml(+)]
	dev-qt/qtwebengine:5
	dev-qt/qtwebsockets:5[qml(+)]
	dev-qt/qtconcurrent:5
	dev-qt/qtimageformats:5
	dev-qt/qtquickcontrols:5
	dev-qt/qtquickcontrols2:5
	media-libs/alsa-lib
	media-libs/libv4l
	media-libs/mesa
	media-libs/speex
	media-libs/speexdsp
	media-sound/alsa-utils
	media-sound/lame[frontend(+)]
	media-video/ffmpeg
	media-video/rtmpdump
	net-dns/c-ares
	net-dns/libidn
	net-nds/openldap
	net-libs/libssh2
	net-misc/curl
	sys-apps/systemd-utils[udev(+)]
	sys-devel/gcc
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXdamage
	x11-libs/libXcomposite
	x11-libs/libXfixes
	x11-libs/libxcb[xkb(+)]
	x11-libs/libxkbcommon[X(+)]
	x11-libs/libXext
	x11-libs/libXrandr
	x11-libs/xcb-util-wm
	x11-libs/xcb-util-image
	x11-libs/xcb-util-keysyms
	x11-libs/xcb-util-renderutil
"

QA_PREBUILT="*"
S=${WORKDIR}
TRUECONF="opt/${PN}/client"

src_unpack() {
	# При распаковке deb сразу всех происходит ошибка, распаковываем по отдельности
	unpack_deb ${P}.deb
	unpack_deb libboost-filesystem1.74.0_${PVR}.deb
	unpack_deb libboost-regex1.74.0_${PVR}.deb
	unpack_deb libcppdb0_0.3.1_${PVR}.deb
	unpack_deb libcppdb-sqlite3-0_0.3.1_${PVR}.deb
	unpack_deb libcurl4_7.88.1_${PVR}.deb
	unpack_deb libicu72_72.1_${PVR}.deb
	unpack_deb libldap-2.5_${PVR}.deb
	unpack_deb libsasl2-2_2.1.28_${PVR}.deb
	unpack_deb libprotobuf32t64_3.21.12_${PVR}.deb
	unpack_deb libmfx1_22.5.4_${PVR}.deb
}

src_prepare() {
	# Перемещаем файлы библиотек в нужное место
	mv usr/lib/x86_64-linux-gnu/libboost* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libcppdb* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libcurl* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libicudata* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libicui18n* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libicuuc* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libl* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libsasl* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libprotobuf* ${TRUECONF}/lib || die
	mv usr/lib/x86_64-linux-gnu/libmfx.so.1* ${TRUECONF}/lib || die

	# Удалить лишнее от распаковки библиотек
	rm -r usr/share/doc || die
	rm -r usr/share/lintian || die
	rm -r usr/lib || die

	# Сделаем недостающие символьные ссылки на библиотеки
	pushd "${S}/${TRUECONF}/lib" > /dev/null || die
	ln -s -f "libcppdb.so.0" "libcppdb.so" || die
	ln -s -f "/usr/lib64/libboost_thread.so" "libboost_thread.so.1.74.0" || die
	ln -s -f "/usr/lib64/libboost_program_options.so" "libboost_program_options.so.1.74.0" || die
	ln -s -f "/usr/lib64/libgs.so" "libgsl.so.27" || die
	ln -s -f "/usr/lib64/libboost_serialization.so" "libboost_serialization.so.1.74.0" || die
	ln -s -f "/usr/lib64/librtmp.so" "librtmp.so.1" || die
	ln -s -f "/usr/lib64/libssh2.so" "libssh2.so.1" || die
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
