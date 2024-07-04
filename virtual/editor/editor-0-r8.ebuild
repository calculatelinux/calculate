# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
# NOTE: This is a version of `virtual/editor-0-r6::gentoo` with additional editors allowed

EAPI=8

DESCRIPTION="Virtual for editor"

SLOT="0"
KEYWORDS="amd64"

RDEPEND="|| (
	app-editors/nano
	app-editors/dav
	app-editors/e3
	app-editors/ee
	app-editors/emacs:*
	app-editors/emact
	app-editors/ersatz-emacs
	app-editors/fe
	app-editors/helix
	app-editors/jasspa-microemacs
	app-editors/jed
	app-editors/joe
	app-editors/jove
	app-editors/kakoune
	app-editors/levee
	app-editors/lpe
	app-editors/mg
	app-editors/micro
	app-editors/moe
	app-editors/ne
	app-editors/neovim
	app-editors/ng
	app-editors/qemacs
	app-editors/teco
	app-editors/uemacs-pk
	app-editors/vile
	app-editors/vim
	app-editors/gvim
	app-editors/vis
	app-editors/xemacs
	app-editors/zile
	app-misc/mc[edit]
	dev-lisp/cmucl
	mail-client/alpine[-onlyalpine]
	sys-apps/busybox
)"
