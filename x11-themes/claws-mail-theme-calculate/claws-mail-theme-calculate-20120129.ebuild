# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit xdg

DESCRIPTION="Iconset Calculate for Claws Mail"
HOMEPAGE="https://www.claws-mail.org/"
SRC_URI="https://www.claws-mail.org/download.php?file=themes/png/claws-mail-theme_Tango_1.2.1.tar.gz"

S="${WORKDIR}/Tango_v1.2.1"

LICENSE="CC-BY-SA-2.5"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="mail-client/claws-mail"

src_install(){
	insinto /usr/share/claws-mail/themes/Calculate
	doins -r *
}
