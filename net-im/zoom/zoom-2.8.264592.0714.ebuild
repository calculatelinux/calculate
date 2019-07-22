# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit unpacker gnome2-utils xdg

MY_PN="${PN/-bin/}"

DESCRIPTION="Video conferencing and web conferencing service"
BASE_SERVER_URI="https://zoom.us"
HOMEPAGE="https://zoom.us"
SRC_URI="amd64? ( ${BASE_SERVER_URI}/client/${PV}/${MY_PN}_x86_64.pkg.tar.xz -> ${MY_PN}-${PV}_x86_64.pkg.tar.xz )"

LICENSE="ZOOM"
SLOT="0"
KEYWORDS="amd64"

RESTRICT="mirror preserve-libs"

IUSE="pulseaudio"

QA_PREBUILT="opt/zoom/*"

DEPEND=""
RDEPEND="${DEPEND}
	pulseaudio? ( media-sound/pulseaudio )
	dev-db/sqlite
	dev-db/unixODBC
	dev-libs/glib
	dev-libs/nss
	dev-libs/libxslt
	media-libs/fontconfig
	media-libs/gstreamer
	media-libs/gst-plugins-base
	media-libs/mesa
	dev-qt/qtsql
	dev-qt/qtconcurrent
	dev-qt/qtmultimedia
	dev-qt/qt3d
	dev-qt/qtquickcontrols2
	dev-qt/qtdeclarative
	dev-qt/qtsvg
	dev-qt/qtxmlpatterns
	x11-libs/libxcb
	x11-libs/libXcomposite
	x11-libs/libXi
	x11-libs/libXrender"

S=${WORKDIR}

src_prepare() {
	rm -rf ${WORKDIR}/.PKGINFO ${WORKDIR}/.INSTALL ${WORKDIR}/.MTREE ${WORKDIR}/usr/share/doc
	sed -i -e 's:Icon=Zoom.png:Icon=Zoom:' "${WORKDIR}/usr/share/applications/Zoom.desktop"
	sed -i -e 's:Application;::' "${WORKDIR}/usr/share/applications/Zoom.desktop"
	eapply_user
}

src_install() {
	insinto /
	doins -r *
	fperms a+x /opt/zoom/{zoom,ZoomLauncher,zoom.sh,zopen,zoomlinux}
}

pkg_preinst() {
	xdg_pkg_preinst
	gnome2_icon_savelist
}

pkg_postinst() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	xdg_desktop_database_update
	xdg_mimeinfo_database_update
	gnome2_icon_cache_update
}

