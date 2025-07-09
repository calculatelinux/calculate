# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# NOTE: This is the modification of `virtual/editor-0-r7::gentoo` with additional editors allowed
# Модификация сводится к добавлению `sys-apps/busybox` в ||-clause RDEPEND'ов.
# Учитывая, что данный пакет входит в сет `@system`, это позволяет иметь в системе
# из перечисленных ниже RDEPEND'ов только `sys-apps/busybox`.

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

# Packages outside app-editors providing an editor:
#	app-misc/mc: mcedit (#62643)
#	dev-lisp/cmucl: hemlock
#	mail-client/alpine: pico
