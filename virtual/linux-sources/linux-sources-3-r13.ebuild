# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

# NOTE: This is a version of `virtual/linux-sources-3-r8::gentoo` adopted to Calculate Linux

EAPI=7

DESCRIPTION="Virtual for Linux kernel sources in Calculate Linux"
SLOT="0"
KEYWORDS="~amd64"
IUSE="firmware"

RDEPEND="
	firmware? ( sys-kernel/linux-firmware )
	|| (
		sys-kernel/calculate-sources
		sys-kernel/gentoo-sources
		sys-kernel/vanilla-sources
		sys-kernel/git-sources
		sys-kernel/pf-sources
		sys-kernel/rt-sources
		sys-kernel/zen-sources
		sys-kernel/gentoo-kernel
		sys-kernel/gentoo-kernel-bin
		sys-kernel/vanilla-kernel
		sys-kernel/fake-sources
	)"
