# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools flag-o-matic readme.gentoo-r1 systemd

MY_P=plymouth-${PV}

DESCRIPTION="Graphical boot animation (splash) and logger"
HOMEPAGE="https://www.freedesktop.org/wiki/Software/Plymouth/"
SRC_URI="${SRC_URI} https://www.freedesktop.org/software/plymouth/releases/${MY_P}.tar.xz"
S="${WORKDIR}/${MY_P}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="debug +drm +gtk +pango +split-usr static-libs +udev"

COMMON_DEPEND="
	>=media-libs/libpng-1.2.16:=
	drm? ( x11-libs/libdrm )
	gtk? (
		dev-libs/glib:2
		>=x11-libs/gtk+-3.14:3
		x11-libs/cairo
	)
	pango? ( >=x11-libs/pango-1.21 )
"
DEPEND="${COMMON_DEPEND}
	elibc_musl? ( sys-libs/rpmatch-standalone )
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
"
# Block due bug #383067
RDEPEND="${COMMON_DEPEND}
	udev? ( virtual/udev )
	sys-kernel/dracut
"

DOC_CONTENTS="
	Follow the following instructions to set up Plymouth:\n
	https://wiki.gentoo.org/wiki/Plymouth#Configuration
"

PATCHES=(
	"${FILESDIR}"/0.9.3-glibc-sysmacros.patch
)

src_prepare() {
	use elibc_musl && append-ldflags -lrpmatch
	default
	cp "${FILESDIR}"/plugin.c "${S}"/src/plugins/splash/two-step/plugin.c
	sed -i 's/two-step/calculate/g' "${S}"/src/plugins/splash/two-step/Makefile.*
	sed -i 's/two_step/calculate/g' "${S}"/src/plugins/splash/two-step/Makefile.*
	eautoreconf
}

src_configure() {
	local myconf=(
		--with-system-root-install=no
		--localstatedir=/var
		--without-rhgb-compat-link
		--enable-documentation
		--enable-systemd-integration
		--with-systemdunitdir="$(systemd_get_systemunitdir)"
		$(use_enable !static-libs shared)
		$(use_enable static-libs static)
		$(use_enable debug tracing)
		$(use_enable drm)
		$(use_enable gtk)
		$(use_enable pango)
		$(use_with udev)
	)
	econf "${myconf[@]}"
}

src_compile() {
	cd src/libply
	emake
	cd ../libply-splash-core
	emake
	cd ../libply-splash-graphics
	emake
	cd ../plugins/splash/two-step
	emake
}

src_install() {
	cd "${S}/src/plugins/splash/two-step"
	emake DESTDIR="${D}" install

	if ! use static-libs; then
		rm "${D}"/usr/$(get_libdir)/plymouth/calculate.la
	fi

	cd "${S}/themes/spinfinity"

	insinto /usr/share/plymouth/themes/calculate
	doins box.png bullet.png entry.png lock.png

	cd "${S}/themes/spinner"
	doins throbber-00*.png

	newins "${FILESDIR}/calculate.plymouth" calculate.plymouth
}
