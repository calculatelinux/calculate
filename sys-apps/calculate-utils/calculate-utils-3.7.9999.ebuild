# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

inherit calculate-utils-r17 git-r3

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="https://www.calculate-linux.org/main/en/calculate_utilities"
SRC_URI=""

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS=""

src_unpack() {
	prepare_module_info
	for MODULE in "${MODULE_INFO[@]}"
	do
		MODULE_DATA=( $MODULE )
		MODULE_PN=${MODULE_DATA[0]/calculate-/}
		EGIT_CHECKOUT_DIR=${WORKDIR}/${MODULE_PN}-${PV} EGIT_REPO_URI=https://git.calculate-linux.org/calculate/calculate-utils-3-${MODULE_PN}.git git-r3_src_unpack
	done
}
