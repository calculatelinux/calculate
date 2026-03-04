# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Common Bash helper library for cl-* utilities with colored output"
HOMEPAGE="https://git.calculate-linux.org/calculate/cl-common-lib"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.calculate-linux.org/calculate/${PN}.git"
else
	SRC_URI="https://git.calculate-linux.org/calculate/cl-common-lib/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/${PN}"
fi

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="
	sys-devel/gettext
"

src_install() {
	insinto /usr/lib/cl-common
	doins lib/*.sh

	dodoc README.md CHANGELOG.md
}
