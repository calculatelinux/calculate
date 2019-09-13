# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="A glossy Matrix collaboration client for the web"
HOMEPAGE="https://riot.im"

inherit eutils gnome2-utils

if [[ ${PV} == "9999" ]]; then
	inherit git-r3

	SRC_URI=""
	EGIT_REPO_URI="https://github.com/vector-im/riot-web.git"
	EGIT_BRANCH="develop"
else
	SRC_URI="https://github.com/vector-im/riot-web/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="Apache-2.0"
SLOT="0"
IUSE="abi_x86_32 abi_x86_64"
REQUIRED_USE="abi_x86_32? ( !abi_x86_64 )
	abi_x86_64? ( !abi_x86_32 )"

DEPEND="sys-devel/binutils:*
	net-libs/nodejs
	sys-apps/yarn
	x11-libs/libXScrnSaver
	net-print/cups
	dev-libs/nss
	gnome-base/gconf"
RDEPEND="${DEPEND}"

QA_PREBUILT="
	opt/Riot/libffmpeg.so
	opt/Riot/libnode.so
	opt/Riot/riot-web"

DESTINATION="/" # We build and unpack a Debian installer, which already has everything in the proper directories {usr,opt}, so we just set the destination to "/"

src_prepare() {
	default

	if [[ ${PV} == "9999" ]]; then
		"${S}"/scripts/fetch-develop.deps.sh
	fi

	yarn install || die "Yarn module installation failed"

	cp "${S}"/config.sample.json "${S}"/config.json
}

src_compile() {
	if use x86; then
		# Currently, by default v8 has a memory limit of 512MB on 32-bit systems,
		# and 1.4GB on 64-bit systems.
		NODE_OPTIONS="--max_old_space_size=1536" yarn run build || die "Build failed"
	else
		yarn run build || die "Build failed"
	fi

	if use abi_x86_32; then
		"${S}"/node_modules/.bin/build --linux --ia32 || die "Bundling failed"
	elif use abi_x86_64; then
		"${S}"/node_modules/.bin/build --linux --x64 || die "Bundling failed"
	fi
}

src_install() {
	ar x "${S}"/electron_app/dist/riot-web*.deb
	tar xvf data.tar.xz

	mv usr/share/doc/${PN} usr/share/doc/${PF}
	gunzip usr/share/doc/${PF}/changelog.gz
	insinto ${DESTINATION}
	doins -r usr
	doins -r opt
	fperms +x /opt/Riot/${PN}
	dosym ${DESTINATION}/opt/Riot/${PN} ${DESTINATION}/usr/bin/${PN}
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
