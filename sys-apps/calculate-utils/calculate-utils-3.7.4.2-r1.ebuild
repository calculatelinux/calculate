# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"
PYTHON_COMPAT=(python3_11)

declare -A CALCULATE_MODULES=(
	["install"]="3.7.4.1"
	["i18n"]="3.7.4.1"
)

inherit calculate-utils-r17

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate_utilities"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64"

