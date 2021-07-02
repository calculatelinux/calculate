# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"
PYTHON_COMPAT=(python3_9)

declare -A CALCULATE_MODULES=(
	["lib"]="3.7.0.3"
	["install"]="3.7.0.1"
	["core"]="3.7.0.3"
	["console-gui"]="3.7.0.2"
	["update"]="3.7.0.1"
)

inherit calculate-utils-r15

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate_utilities"

LICENSE="Apache-2.0"
SLOT="3.7"
KEYWORDS="~amd64"

