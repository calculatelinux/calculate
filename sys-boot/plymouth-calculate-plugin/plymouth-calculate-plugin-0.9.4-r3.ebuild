# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

MY_P=plymouth-${PV}

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://anongit.freedesktop.org/git/plymouth"
else
	SRC_URI="${SRC_URI} https://www.freedesktop.org/software/plymouth/releases/${MY_P}.tar.xz"
	KEYWORDS="~alpha amd64 ~arm ~ia64 ~ppc ~ppc64 ~sparc x86"
fi

inherit autotools readme.gentoo-r1 systemd toolchain-funcs

DESCRIPTION="Calculate plugin for plymouth"
HOMEPAGE="https://www.calculate-linux.org/"

LICENSE="GPL-2"
SLOT="0"
IUSE="debug gdm +gtk +libkms +pango +split-usr static-libs"

CDEPEND="
	~sys-boot/${MY_P}[debug?,gdm?,gtk?,libkms?,pango?,split-usr?,static-libs?]
"
DEPEND="${CDEPEND}
	app-text/docbook-xsl-stylesheets
	dev-libs/libxslt
	virtual/pkgconfig
"
RDEPEND="${CDEPEND}
	virtual/udev
	!<sys-kernel/dracut-0.37-r3
"

PATCHES=(
	"${FILESDIR}"/0.9.3-glibc-sysmacros.patch
)

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default
	cp ${FILESDIR}/plugin.c ${S}/src/plugins/splash/throbgress
	sed -i 's/throbgress/calculate/g' ${S}/src/plugins/splash/throbgress/Makefile.*
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
		$(use_enable gtk gtk)
		$(use_enable libkms drm)
		$(use_enable pango)
		$(use_enable gdm gdm-transition)
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
	cd ../plugins/splash/throbgress
	emake
}

src_install() {
	cd ${S}/src/plugins/splash/throbgress
	emake DESTDIR="${D}" install

	cd ${S}/themes/spinfinity

	insinto /usr/share/plymouth/themes/calculate
	doins box.png bullet.png entry.png lock.png

	cd ${S}/themes/spinner
	doins throbber-00*.png

	doins ${FILESDIR}/calculate.plymouth
}
