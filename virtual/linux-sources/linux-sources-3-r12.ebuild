# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/virtual/linux-sources/linux-sources-1.ebuild,v 1.4 2014/04/03 01:35:05 tomwij Exp $

EAPI=7

DESCRIPTION="Virtual for Linux kernel sources"
SLOT="0"
KEYWORDS="amd64"

RDEPEND="|| (
		sys-kernel/calculate-sources
		sys-kernel/gentoo-sources
		sys-kernel/vanilla-sources
		sys-kernel/git-sources
		sys-kernel/mips-sources
		sys-kernel/pf-sources
		sys-kernel/rt-sources
		sys-kernel/zen-sources
		sys-kernel/raspberrypi-sources
		sys-kernel/gentoo-kernel
		sys-kernel/gentoo-kernel-bin
		sys-kernel/vanilla-kernel
		sys-kernel/fake-sources
	)"
