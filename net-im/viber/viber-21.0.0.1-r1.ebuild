# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MULTILIB_COMPAT=( abi_x86_64 )

inherit desktop multilib-build pax-utils unpacker xdg

DESCRIPTION="Free and secure calls and messages to anyone, anywhere"
HOMEPAGE="https://www.viber.com/"
SRC_URI="
	amd64? (
		https://download.cdn.viber.com/cdn/desktop/Linux/${PN}.deb -> ${P}.deb
	)
"

QA_PRESTRIPPED="
	opt/viber/Viber
	opt/viber/libexec/QtWebEngineProcess
	opt/viber/lib/libicudata.so.66
	opt/viber/lib/libssl.so.1.1
	opt/viber/lib/libcrypto.so.1.1
	opt/viber/lib/libXcomposite.so.1
	opt/viber/lib/libwebp.so.6
	opt/viber/lib/libicui18n.so.66
	opt/viber/lib/libqrencode.so
	opt/viber/lib/libViberRTC.so
	opt/viber/lib/libminizip.so.1
	opt/viber/lib/libdouble-conversion.so.3
	opt/viber/lib/libicuuc.so.66
	opt/viber/lib/libpng16.so.16
	opt/viber/lib/libXdamage.so.1
	opt/viber/lib/libb2.so.1
	opt/viber/lib/libjpeg.so.8
	opt/viber/lib/libpcre2-16.so.0
	opt/viber/lib/libre2.so.5
"

LICENSE="Viber"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE="+abi_x86_64 apulse +pulseaudio"
REQUIRED_USE="
	^^ ( apulse pulseaudio )
"
RESTRICT="bindist mirror"

BDEPEND="
	sys-apps/fix-gnustack
"
RDEPEND="
	app-arch/brotli:=[${MULTILIB_USEDEP}]
	app-arch/snappy:=[${MULTILIB_USEDEP}]
	app-arch/zstd:=[${MULTILIB_USEDEP}]
	app-crypt/mit-krb5[${MULTILIB_USEDEP}]
	dev-libs/expat[${MULTILIB_USEDEP}]
	dev-libs/glib:2[${MULTILIB_USEDEP}]
	dev-libs/libevent:=[${MULTILIB_USEDEP}]
	dev-libs/libxml2[${MULTILIB_USEDEP}]
	dev-libs/libxslt[${MULTILIB_USEDEP}]
	dev-libs/nspr[${MULTILIB_USEDEP}]
	dev-libs/nss[${MULTILIB_USEDEP}]
	dev-libs/wayland[${MULTILIB_USEDEP}]
	media-libs/alsa-lib[${MULTILIB_USEDEP}]
	media-libs/fontconfig:1.0[${MULTILIB_USEDEP}]
	media-libs/freetype:2[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-bad:1.0[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-base:1.0[${MULTILIB_USEDEP}]
	media-libs/gst-plugins-good:1.0[${MULTILIB_USEDEP}]
	media-plugins/gst-plugins-libav:1.0[${MULTILIB_USEDEP}]
	media-libs/gstreamer:1.0[${MULTILIB_USEDEP}]
	media-libs/harfbuzz:=[${MULTILIB_USEDEP}]
	media-libs/lcms:2[${MULTILIB_USEDEP}]
	media-libs/libglvnd[${MULTILIB_USEDEP}]
	media-libs/libmng:=[${MULTILIB_USEDEP}]
	media-libs/libwebp:=[${MULTILIB_USEDEP}]
	media-libs/opus[${MULTILIB_USEDEP}]
	media-libs/mesa[${MULTILIB_USEDEP}]
	media-libs/tiff-compat:4[${MULTILIB_USEDEP}]
	net-print/cups[${MULTILIB_USEDEP}]
	sys-apps/dbus[${MULTILIB_USEDEP}]
	|| (
		sys-apps/systemd[${MULTILIB_USEDEP}]
		sys-apps/systemd-utils[udev,${MULTILIB_USEDEP}]
	)
	sys-libs/mtdev
	sys-libs/zlib:0/1[${MULTILIB_USEDEP}]
	x11-libs/gdk-pixbuf:2[${MULTILIB_USEDEP}]
	x11-libs/gtk+:3[${MULTILIB_USEDEP}]
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libICE[${MULTILIB_USEDEP}]
	x11-libs/libSM[${MULTILIB_USEDEP}]
	x11-libs/libX11[${MULTILIB_USEDEP}]
	x11-libs/libxcb:0/1.12[${MULTILIB_USEDEP}]
	x11-libs/libXext[${MULTILIB_USEDEP}]
	x11-libs/libXfixes[${MULTILIB_USEDEP}]
	x11-libs/libxkbcommon[${MULTILIB_USEDEP}]
	x11-libs/libxkbfile[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libXScrnSaver[${MULTILIB_USEDEP}]
	x11-libs/libXtst[${MULTILIB_USEDEP}]
	x11-libs/pango[${MULTILIB_USEDEP}]
	x11-libs/tslib[${MULTILIB_USEDEP}]
	x11-libs/xcb-util-cursor[${MULTILIB_USEDEP}]
	x11-libs/xcb-util-image[${MULTILIB_USEDEP}]
	x11-libs/xcb-util-keysyms[${MULTILIB_USEDEP}]
	x11-libs/xcb-util-renderutil[${MULTILIB_USEDEP}]
	x11-libs/xcb-util-wm[${MULTILIB_USEDEP}]
	apulse? ( media-sound/apulse[${MULTILIB_USEDEP}] )
	pulseaudio? (
		media-libs/libpulse[glib,${MULTILIB_USEDEP}]
		media-plugins/gst-plugins-pulse:1.0[${MULTILIB_USEDEP}]
	)
"

S="${WORKDIR}"

src_prepare() {
	default

	if use apulse ; then
		sed -i '/Exec=/s|/opt|apulse /opt|' \
			usr/share/applications/viber.desktop || die "sed failed"
	fi

	# remove hardcoded path
	sed -i '/Icon/s|/usr/share/pixmaps/viber.png|viber|' \
		usr/share/applications/viber.desktop \
		|| die "sed failed for viber.desktop"
}

src_install() {
	newicon -s scalable usr/share/icons/hicolor/scalable/apps/Viber.svg \
		viber.svg
	for size in 16x16 24x24 32x32 48x48 64x64 96x96 128x128 256x256; do
		newicon -s "${size%%x*}" usr/share/viber/"${size}".png viber.png
	done
	dosym ../icons/hicolor/96x96/apps/viber.png \
		/usr/share/pixmaps/viber.png

	domenu usr/share/applications/viber.desktop

	insinto /opt/viber
	doins -r opt/viber/.

	pax-mark -m "${ED}"/opt/viber/Viber \
			"${ED}"/opt/viber/QtWebEngineProcess

	fix-gnustack -f "${ED}"/opt/viber/lib/libQt6WebEngineCore.so.6 > /dev/null \
		|| die "removing execstack flag failed"

	fperms +x /opt/viber/Viber \
		/opt/viber/lib/libQt6Core.so.6 \
		/opt/viber/libexec/QtWebEngineProcess

	dosym ../../opt/viber/Viber /usr/bin/Viber
}
