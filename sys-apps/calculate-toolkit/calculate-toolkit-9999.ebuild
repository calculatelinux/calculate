# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{9..12} )

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://git.calculate-linux.org/calculate/calculate-toolkit.git"
else
	SRC_URI="https://git.calculate-linux.org/calculate/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}"
	KEYWORDS="amd64"
fi

DESCRIPTION="Collection of administration scripts for Calculate"
HOMEPAGE="https://www.calculate-linux.org"

LICENSE="Apache-2.0"
SLOT="0"

RDEPEND=">=sys-apps/calculate-utils-3.6
	app-arch/zstd
	app-arch/xz-utils"
