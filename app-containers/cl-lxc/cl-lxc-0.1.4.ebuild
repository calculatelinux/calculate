# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Automates creation and upgrade of Calculate Linux LXC containers"
HOMEPAGE="https://git.lautre.me/alex/cl-lxc"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.calculate-linux.org/calculate/${PN}.git"
else
	SRC_URI="https://git.calculate-linux.org/calculate/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/${PN}"
fi

LICENSE="Apache-2.0"
SLOT="0"

BDEPEND="
	sys-devel/gettext
"
RDEPEND="
	app-containers/lxc
	app-shells/bash
	dev-vcs/git
	sys-apps/openrc
	sys-apps/util-linux
	sys-devel/gettext
"

src_compile() {
	emake VERSION="${PV}"
}

src_install() {
	emake install DESTDIR="${D}"
	dodoc README.md
}
