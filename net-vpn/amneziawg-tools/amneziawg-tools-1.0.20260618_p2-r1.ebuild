# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit bash-completion-r1 toolchain-funcs

DESCRIPTION="Userspace command line utilities for AmneziaWG, such as awg(8) and awg-quick(8)"
HOMEPAGE="https://github.com/amnezia-vpn/amneziawg-tools"
MY_PV="${PV%%-r*}"
MY_PV="${MY_PV/_p/-}"
SRC_URI="https://github.com/amnezia-vpn/amneziawg-tools/archive/refs/tags/v${MY_PV}.tar.gz -> ${PN}-${PV%%-r*}.tar.gz"

S="${WORKDIR}/${PN}-${MY_PV}"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

PATCHES=( "${FILESDIR}/awg-quick-adopt-daemon.patch" )

BDEPEND="virtual/pkgconfig"
RDEPEND="
	|| ( net-firewall/nftables net-firewall/iptables )
	virtual/resolvconf
"

src_compile() {
	emake RUNSTATEDIR="${EPREFIX}/run" -C src CC="$(tc-getCC)" LD="$(tc-getLD)"
}

src_install() {
	dodoc README.md
	emake \
		WITH_BASHCOMPLETION=yes \
		WITH_SYSTEMDUNITS=no \
		WITH_WGQUICK=yes \
		DESTDIR="${D}" \
		BASHCOMPDIR="$(get_bashcompdir)" \
		PREFIX="${EPREFIX}/usr" \
		-C src install
}
