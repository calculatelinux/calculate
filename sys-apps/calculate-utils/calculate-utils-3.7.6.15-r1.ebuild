# Copyright 2007-2024 Mir Calculate
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_EXT=1
DISTUTILS_USE_PEP517=setuptools

PYTHON_COMPAT=( python3_{11..13} )

DESCRIPTION="A set of Calculate utilities for system installation, build and upgrade"
HOMEPAGE="http://www.calculate-linux.org/main/en/calculate_utilities"

LICENSE="Apache-2.0"
SLOT="0"

export SETUPTOOLS_SCM_PRETEND_VERSION=${PV}
inherit distutils-r1

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_BRANCH="master"
	EGIT_REPO_URI="https://git.calculate-linux.org/calculate/calculate-utils.git"
else
	SRC_URI="https://git.calculate-linux.org/calculate/calculate-utils/archive/${PV}.tar.gz -> calculate-utils-${PV}.tar.gz"
	KEYWORDS="amd64"
	S="${WORKDIR}/${PN}"
fi

IUSE="backup client console dbus desktop +gpg +install minimal pxe qt6"
distutils_enable_tests unittest

CALCULATE_MODULES_=(
	"core"
	"builder"
	"update"
	"i18n"
	"lib"
	"install"
)

declare -g -A CALCULATE_MODULES_USE_=(
	["console-gui"]="qt6"
	["desktop"]="desktop"
	["client"]="client"
	["console"]="console"
)

python_prepare_all() {
	distutils-r1_python_prepare_all

	local core_file_path="src/calculate/core/wsdl_core.py"
	if ! use backup; then
		sed -ir "s/'cl-backup'/None/" $core_file_path
		sed -ir "s/'cl-backup-restore'/None/" $core_file_path
		sed -ir "s/__('Backup')/None/g" $core_file_path

		einfo "Disable backups in core module"
	fi

	local lib_file_path="src/calculate/lib/variables/__init__.py"
	sed -ri "/class VariableClVer/{N;N;N;N;s/value = \".*?\"/value = \"${PV}\"/;}" \
		$lib_file_path || die
	einfo "Change version in $lib_file_path => $PV"

	use_flags=()
	for exc_module in ${!CALCULATE_MODULES_USE_[@]}; do
		use_flag=${CALCULATE_MODULES_USE_[$exc_module]}
		if ! use $use_flag; then
			[[ $exc_module == "console-gui" ]] && exc_module="consolegui"
			remove_path="src/calculate/${exc_module}"
			rm -rf ${remove_path} || die "Can't remove module from path: ${remove_path}"
			elog "Module calculate.${exc_module} removed."
		else
			[[ $exc_module == "console-gui" ]] && use_flag="console-gui"
			use_flags+=(${use_flag})
		fi
	done
	use_flags=${use_flags[@]}

	cat >> setup.cfg <<-EOF

	[use_flags]
	flags = ${use_flags// /,}
	EOF
}

python_configure() {
	esetup.py build_mo
}

install_openrc_daemons() {
	debug-print-function ${FUNCNAME} "${@}"

	doinitd $(find "resources/scripts/openrc_daemon" -maxdepth 1 -type f)
	use client && doinitd resources/scripts/openrc_daemon/client/*
}

install_xdm() {
	debug-print-function ${FUNCNAME} "${@}"

	local xdm_pth="/usr/share/calculate/xdm"
	exeinto ${xdm_pth}
	insinto ${xdm_pth}
	if use desktop; then
		doexe $(find "resources/scripts/xdm_files/desktop" -executable -type f)
		doins $(find "resources/scripts/xdm_files/desktop" ! -executable -type f)
	fi

	use client && doexe resources/scripts/xdm_files/client/wait_domain

	insinto /usr/share/calculate/xdm/login.d
	if use desktop; then
		doins resources/scripts/xdm_files/login.d/desktop/*
	fi

	use client && doins resources/scripts/xdm_files/login.d/client/*

	insinto /usr/share/calculate/xdm/logout.d
	use desktop && doins resources/scripts/xdm_files/logout.d/desktop/*
	use client && doins resources/scripts/xdm_files/logout.d/client/*
}

install_sbin() {
	debug-print-function ${FUNCNAME} "${@}"

	dosbin $(find "resources/scripts/sbin" -maxdepth 1 -type f)
	use client && dosbin resources/scripts/sbin/client/*
}

install_man() {
	debug-print-function ${FUNCNAME} "${@}"

	doman -i18n=ru resources/man/ru/*.1
	doman resources/man/*.1
}

install_libexec() {
	debug-print-function ${FUNCNAME} "${@}"

	exeinto /usr/libexec/calculate

	use dbus && doexe resources/scripts/libexec/dbus/*
	doexe $(find "resources/scripts/libexec" -maxdepth 1 -type f)
}

install_doc() {
	debug-print-function ${FUNCNAME} "${@}"

	dodoc -r resources/*.html
}

install_bin() {
	debug-print-function ${FUNCNAME} "${@}"

	exeinto /bin
	doexe resources/scripts/bin/*
	exeinto /usr/bin
	doexe resources/scripts/usr/bin/*
}

install_data_images() {
	debug-print-function ${FUNCNAME} "${@}"

	local themes=("gnome" "hicolor")

	insinto /usr/share/icons/Calculate/16x16/client-gui
	doins -r resources/data/images/*

	insinto /usr/share/
	doins -r resources/data/pixmaps
	doins -r resources/data/applications

	insinto /usr/share/calculate/themes/
	doins -r resources/data/install

	for theme in ${themes[@]}; do
		insinto /usr/share/icons/${theme}
		doins -r resources/data/non_scalable/*

		insinto /usr/share/icons/${theme}/scalable/apps
		doins -r resources/data/scalable/*
	done
}

python_install() {
	if use qt6; then
		local scriptdir=${EPREFIX}/usr/bin
		local root=${BUILD_DIR}/install
		local reg_scriptdir=${root}/${scriptdir}

		python_newscript ${reg_scriptdir}/cl-console-gui cl-console-gui-install
		python_newscript ${reg_scriptdir}/cl-console-gui cl-console-gui-update

		install_data_images

		insinto /etc/xdg/autostart
		doins resources/data/cl-update-checker.desktop
	fi

	distutils-r1_python_install

	install_openrc_daemons
	install_libexec
	install_xdm
	install_sbin
	install_man
	install_doc
	install_bin

	if use dbus; then
		insinto /usr/share/dbus-1/system.d
		doins resources/configs/conf/*

		insinto /usr/share/dbus-1/system-services
		doins resources/configs/service/*
	fi

	# domo "${S}"/src/calculate/locale/**/LC_MESSAGES/*.mo

	keepdir /etc/calculate
	keepdir /var/log/calculate
}

pkg_preinst() {
	dosym -r /usr/libexec/calculate/cl-core-wrapper /usr/bin/cl-core-setup
	dosym -r /usr/libexec/calculate/cl-core-wrapper /usr/bin/cl-core-patch
	dosym -r /usr/libexec/calculate/cl-core-wrapper /usr/bin/cl-update
	dosym -r /usr/libexec/calculate/cl-core-wrapper /usr/bin/cl-update-profile
}

BDEPEND="$(python_gen_cond_dep 'dev-python/setuptools-scm[${PYTHON_USEDEP}]')"

RDEPEND="
	dev-libs/libbsd
	install? ( >=app-cdr/cdrtools-3.01_alpha13
		>=sys-boot/grub-2.00-r3
		>=sys-boot/syslinux-5
		sys-fs/squashfs-tools
		sys-fs/dosfstools
		sys-block/parted
		sys-apps/gptfdisk
		sys-fs/lvm2
		sys-fs/mdadm
	)
	!minimal? (
		>=sys-apps/util-linux-2.19.1
		net-misc/rsync
		dev-python/pyopenssl[${PYTHON_USEDEP}]
		dev-python/cryptography[${PYTHON_USEDEP}]
		dev-python/cffi[${PYTHON_USEDEP}]
		dev-python/six[${PYTHON_USEDEP}]
		dev-libs/openssl
		dev-python/m2crypto[${PYTHON_USEDEP}]
		dev-python/pytz[${PYTHON_USEDEP}]
	)
	gpg? (
		app-crypt/gnupg
		app-crypt/openpgp-keys-calculate-release
	)
	dev-python/jaraco-functools[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/aiohttp
	sys-apps/iproute2[-minimal]
	sys-apps/pciutils
	app-arch/xz-utils
	app-portage/eix
	app-portage/portage-utils

	sys-apps/debianutils
	sys-kernel/installkernel

	app-eselect/eselect-repository
	>=virtual/udev-197
	!app-misc/livecd-tools
	sys-apps/coreutils[xattr]

	pxe? ( sys-apps/calculate-server
		net-ftp/tftp-hpa
		net-misc/dhcp
		net-fs/nfs-utils
	)

	!<sys-apps/calculate-server-2.1.18-r1

	qt6? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
		media-gfx/imagemagick[jpeg]
		dev-python/PyQt6[${PYTHON_USEDEP}]
		dev-python/pyinotify[${PYTHON_USEDEP}]
	)

	dbus? (
		dev-python/dbus-python[${PYTHON_USEDEP}]
	)

	dev-python/pexpect[${PYTHON_USEDEP}]

	desktop? (
		media-gfx/feh
		x11-apps/xmessage
		sys-apps/keyutils
		sys-auth/pam_keystore
		dev-lang/swig
		dev-qt/qdbus
		sys-apps/edid-decode
		dev-python/pygobject[${PYTHON_USEDEP}]
		dev-python/dbus-python[${PYTHON_USEDEP}]
	)

	client? (
		dev-python/python-ldap[ssl,${PYTHON_USEDEP}]
		sys-auth/pam_client
		=sys-auth/sssd-2.9.4
		net-nds/openldap[experimental]
	)
	backup? ( !sys-apps/calculate-server )
"
#	server? (
#		sys-auth/pam_ldap
#		sys-auth/nss_ldap
#		dev-python/python-ldap[${PYTHON_USEDEP}]
#	)
#
#
#	server? ( !sys-apps/calculate-server )

DEPEND="
	sys-devel/gettext"

#REQUIRED_USE="client? ( desktop )"
