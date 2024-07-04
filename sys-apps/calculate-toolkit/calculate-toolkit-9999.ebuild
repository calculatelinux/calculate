# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=8

inherit git-r3

DESCRIPTION="Collection of administration scripts for Calculate"
HOMEPAGE="https://www.calculate-linux.org/main/en/calculate_toolkit"
EGIT_REPO_URI="https://git.calculate-linux.org/calculate/calculate-toolkit"

LICENSE="Apache-2.0"
SLOT="0"
RDEPEND=">=sys-apps/calculate-utils-3.3.0.10"
