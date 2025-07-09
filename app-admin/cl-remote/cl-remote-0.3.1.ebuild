# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Parallel SSH execution of shell scripts on multiple hosts"
HOMEPAGE="https://git.calculate-linux.org/calculate/cl-remote"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.calculate-linux.org/calculate/${PN}.git"
else
	SRC_URI="https://git.calculate-linux.org/calculate/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="
	sys-devel/gettext
"
RDEPEND="
	net-dns/bind-tools
	net-misc/iputils
	net-misc/openssh
	net-misc/sshpass
	sys-apps/coreutils
	sys-apps/iproute2
	sys-devel/gettext
	sys-process/procps
"

src_compile() {
	emake VERSION="${PV}"
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc README.md
}
