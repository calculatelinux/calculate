# Copyright 2007-2024 Mir Calculate
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=(python3_12)

declare -A CALCULATE_MODULES=(
	["install"]="3.7.5.2"
	["builder"]="3.7.5.2"
)

inherit calculate-utils-r18

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="https://www.calculate-linux.org/main/en/calculate_utilities"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64"
