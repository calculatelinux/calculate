# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

inherit calculate
EAPI=2

DESCRIPTION="Calculate Linux Desktop KDE (meta package)"
HOMEPAGE="http://www.calculate-linux.org/main/en/cld"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	app-misc/cls-meta
	app-misc/cl-desktop-meta
	app-misc/cl-kde-meta
"
# Decoration
RDEPEND="${RDEPEND}
	media-gfx/cld-themes
	x11-themes/gtk-engines-qtcurve
"
# Graphics
RDEPEND="${RDEPEND}
	media-gfx/digikam
"
# Multimedia
RDEPEND="${RDEPEND}
	media-sound/amarok
	media-plugins/kipi-plugins
	media-video/dvdauthor
	media-video/dvgrab
	media-video/kdenlive
	media-video/kffmpegthumbnailer
	media-video/recordmydesktop
	media-video/smplayer
"
# Network
RDEPEND="${RDEPEND}
	net-irc/konversation
	net-p2p/eiskaltdc
"
# Nettools
RDEPEND="${RDEPEND} 
	net-misc/kvpnc
	net-misc/wicd
"
# Office
RDEPEND="${RDEPEND}
	app-dicts/goldendict
	app-text/fbreader
"
# Tools
RDEPEND="${RDEPEND}
	app-cdr/k3b
	sys-block/partitionmanager
"

