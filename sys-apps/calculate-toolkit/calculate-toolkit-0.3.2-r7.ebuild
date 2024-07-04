# Copyright 2007-2023 Mir Calculate
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{9..12} )

DESCRIPTION="Collection of administration scripts for Calculate"
HOMEPAGE="https://www.calculate-linux.org"
SRC_URI="https://git.calculate-linux.org/calculate/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"

RDEPEND=">=sys-apps/calculate-utils-3.6
	app-arch/zstd
	app-arch/xz-utils"

PATCHES=(
	"${FILESDIR}"/${P}-20230215.patch
	"${FILESDIR}"/${P}-fix_message.patch
	"${FILESDIR}"/${P}-start_services.patch
	"${FILESDIR}"/${P}-update_overlay.patch
	"${FILESDIR}"/${P}-fix_dir.patch
)
