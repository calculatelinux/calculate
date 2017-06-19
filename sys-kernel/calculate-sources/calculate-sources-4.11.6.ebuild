# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
ETYPE="sources"

inherit calculate-kernel-7 eutils

DESCRIPTION="Calculate Linux kernel image"
KEYWORDS="~amd64 ~x86"
HOMEPAGE="http://www.calculate-linux.org"

SRC_URI="${KERNEL_URI} ${ARCH_URI}"

src_unpack() {
	calculate-kernel-7_src_unpack
}

pkg_postinst() {
	calculate-kernel-7_pkg_postinst
}
