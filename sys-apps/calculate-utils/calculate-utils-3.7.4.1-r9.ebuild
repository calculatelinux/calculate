# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="8"

UTILS_PV="3.7.3"

declare -A CALCULATE_MODULES=(
	["lib"]="3.7.3.22"
	["install"]="3.7.3.8"
	["core"]="3.7.3.3"
	["i18n"]="3.7.3.6"
	["client"]="3.7.3.4"
	["console"]="3.7.3.1"
	["console-gui"]="3.7.3.1"
	["update"]="3.7.3.9"
	["builder"]="3.7.3.7"
)

inherit calculate-utils-r17

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate_utilities"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64"

