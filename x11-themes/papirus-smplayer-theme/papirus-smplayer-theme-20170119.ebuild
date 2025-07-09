# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Papirus icon themes for SMPlayer"
HOMEPAGE="https://github.com/PapirusDevelopmentTeam/papirus-smplayer-theme"
if [[ ${PV} == 99999999 ]];then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="https://github.com/PapirusDevelopmentTeam/papirus-smplayer-theme/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="GPL-3"
SLOT="0"

RDEPEND="media-video/smplayer"
