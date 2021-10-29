# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"
PYTHON_COMPAT=(python3_9)

declare -A CALCULATE_MODULES=(
	["lib"]="3.7.1.22"
	["install"]="3.7.1.8"
	["core"]="3.7.1.5"
	["i18n"]="3.7.1.1"
	["client"]="3.7.1.1"
	["console"]="3.7.1.2"
	["console-gui"]="3.7.1.2"
	["update"]="3.7.1.7"
	["builder"]="3.7.1.6"
)

inherit calculate-utils-r15

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate_utilities"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64"

