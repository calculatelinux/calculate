# Copyright 1999-2024 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

# @ECLASS: calculate-utils-r16.eclass
# @MAINTAINER:
# support@calculate.ru
# @AUTHOR:
# Author: Mir Calculate
# @BLURB: Functions for calculate-utils
# @DESCRIPTION:
# This eclass use for calculate-utils ebuild

PYTHON_COMPAT=(python3_12)

inherit distutils-r1

EXPORTED_FUNCTIONS="src_compile src_install pkg_preinst"

CALCULATE_URI="https://mirror.calculate-linux.org/source/calculate3"
MIRROR_URI=

# @ECLASS_VARIABLE: CALCULATE_MODULES
# @DESCRIPTION:
# Associative array module names and versions
# Example:
# declare -A CALCULATE_MODULES=(
#   ["console-gui"]="3.2.3.4"
# )

# @ECLASS_VARIABLE: CALCULATE_MODULES_USE
# @DESCRIPTION:
# Associative array module names and use for IUSE
# Example:
# declare -A CALCULATE_MODULES_USE=(
#   ["console-gui"]=""
# )

# @ECLASS_VARIABLE: CALCULATE_TARBALL
# @DESCRIPTION:
# Associative array module names and tarball archive name
# Example:
# declare -A CALCULATE_TARBALL=( ["lib"]="calculate-lib-3.2.3-r1.tar.bz2" )

# @ECLASS_VARIABLE: UTILS_PV
# @DESCRIPTION:
# Default version of all components
# Example:
: ${UTILS_PV:=$(ver_cut 1-3 ${PV})}

declare -g -A CALCULATE_TARBALL_=()

declare -g -A CALCULATE_MODULES_=(
	["lib"]="$UTILS_PV"
	["install"]="$UTILS_PV"
	["core"]="$UTILS_PV"
	["update"]="$UTILS_PV"
	["console-gui"]="$UTILS_PV"
	["builder"]="$UTILS_PV"
	["i18n"]="$UTILS_PV"
	["desktop"]="$UTILS_PV"
	["client"]="$UTILS_PV"
	["console"]="$UTILS_PV"
)

declare -g -A CALCULATE_MODULES_USE_=(
	["console-gui"]="qt5"
	["desktop"]="desktop"
	["client"]="client"
	["console"]="console"
)

EXPORT_FUNCTIONS ${EXPORTED_FUNCTIONS}

# @FUNCTION: prepare_variables
# @DESCRIPTION:
# Prepare variables for ebuild
prepare_variables() {
	for module in ${!CALCULATE_MODULES[@]}
	do
		CALCULATE_MODULES_[$module]=${CALCULATE_MODULES[$module]}
	done

	for module in ${!CALCULATE_MODULES_USE[@]}
	do
		CALCULATE_MODULES_USE_[$module]=${CALCULATE_MODULES_USE[$module]}
	done

	for module in ${!CALCULATE_MODULES_[@]}
	do
		MODULE_PN=calculate-${module}
		MODULE_PV=${CALCULATE_MODULES_[$module]}
		if [[ -n ${CALCULATE_TARBALL[$module]} ]]
		then
			CALCULATE_TARBALL_[$module]="${MODULE_PN}/${CALCULATE_TARBALL[$module]}"
		else
			CALCULATE_TARBALL_[$module]="${MODULE_PN}/${MODULE_PN}-${MODULE_PV}.tar.bz2"
		fi
	done

	for module in ${!CALCULATE_MODULES_[@]}
	do
		MODULE_USE=${CALCULATE_MODULES_USE_[$module]}
		MODULE_URI=""
		for URI in $CALCULATE_URI $MIRROR_URI
		do
			MODULE_URI="${MODULE_URI} ${URI}/${CALCULATE_TARBALL_[$module]}"
		done
		if [[ -n $MODULE_USE ]]
		then
			MODULE_URI="${MODULE_USE}? ( $MODULE_URI )"
		fi
		SRC_URI="$SRC_URI $MODULE_URI"
	done

	IUSE="+install dbus +gpg minimal pxe backup ${CALCULATE_MODULES_USE_[@]}"
	S="${WORKDIR}"
}

# @FUNCTION: prepare_module_info
# @DESCRIPTION:
# Prepare module info for compile and install
prepare_module_info() {
	MODULE_INFO=()
	for module in ${!CALCULATE_MODULES_[@]}
	do
		MODULE_USE=${CALCULATE_MODULES_USE_[$module]}
		if [[ -z $MODULE_USE ]] || use $MODULE_USE
		then
				MODULE_INFO+=("calculate-$module ${CALCULATE_MODULES_[$module]}")
		fi
	done
}

prepare_variables

# dev-libs/libbsd need to automagic depends of sys-fs/mtools

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
		dev-python/pyopenssl[python_targets_python3_12]
		dev-python/cryptography[python_targets_python3_12]
		dev-python/cffi[python_targets_python3_12]
		dev-python/six[python_targets_python3_12]
		dev-libs/openssl
		dev-python/m2crypto[python_targets_python3_12]
		dev-python/pytz[python_targets_python3_12]
	)
	gpg? (
		app-crypt/gnupg
		app-crypt/openpgp-keys-calculate-release
	)
	dev-python/jaraco-functools[python_targets_python3_12]
	dev-python/lxml[python_targets_python3_12]
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

	qt5? (
		dev-python/dbus-python[python_targets_python3_12]
		media-gfx/imagemagick[jpeg]
		dev-python/PyQt5[python_targets_python3_12]
		dev-python/pyinotify[python_targets_python3_12]
	)

	dbus? (
		dev-python/dbus-python[python_targets_python3_12]
	)

	dev-python/pexpect[python_targets_python3_12]

	desktop? (
		media-gfx/feh
		x11-apps/xmessage
		sys-apps/keyutils
		sys-auth/pam_keystore
		dev-lang/swig
		dev-qt/qdbus
		sys-apps/edid-decode
		dev-python/pygobject[python_targets_python3_12]
		dev-python/dbus-python[python_targets_python3_12]
	)

	client? (
		dev-python/python-ldap[ssl,python_targets_python3_12]
		sys-auth/pam_client
		>=sys-auth/pam_ldap-180[ssl]
		>=sys-auth/nss_ldap-239
	)
	backup? ( !sys-apps/calculate-server )
"
#	server? (
#		sys-auth/pam_ldap
#		sys-auth/nss_ldap
#		dev-python/python-ldap[python_targets_python3_12]
#	)
#
#
#	server? ( !sys-apps/calculate-server )

DEPEND="
	sys-devel/gettext"

#REQUIRED_USE="client? ( desktop )"

# @FUNCTION: calculate-utils-r15_src_compile
# @DESCRIPTION:
# Compile all modules of calculate utils
calculate-utils-r18_src_compile() {
	if ! use backup
	then
		sed -ir "s/'cl-backup'/None/" calculate-core-*/pym/core/wsdl_core.py
		sed -ir "s/'cl-backup-restore'/None/" calculate-core-*/pym/core/wsdl_core.py
		sed -ir "s/__('Backup')/None/g" calculate-core-*/pym/core/wsdl_core.py
	fi
	prepare_module_info
	for MODULE in "${MODULE_INFO[@]}"
	do
		MODULE_DATA=( $MODULE )
		MODULE_PN=${MODULE_DATA[0]}
		MODULE_PV=${MODULE_DATA[1]}
		if [[ $PV == "3.7.9999" ]]
		then
			S="${WORKDIR}/${MODULE_PN/calculate-/}-${MODULE_PV}"
		else
			S="${WORKDIR}/${MODULE_PN}-${MODULE_PV}"
		fi
		cd "$S"
		if [[ $MODULE_PN == "calculate-lib" ]]
		then
			sed -ri "/class VariableClVer/{N;N;N;N;s/value = \".*?\"/value = \"${PV}\"/;}" \
				pym/calculate/lib/variables/__init__.py
		fi
		distutils-r1_src_compile
	done
}

# @FUNCTION: calculate-utils-r15_src_install
# @DESCRIPTION:
# Install all modules of calculate utils
calculate-utils-r18_src_install() {
	prepare_module_info
	for MODULE in "${MODULE_INFO[@]}"
	do
		MODULE_DATA=( $MODULE )
		MODULE_PN=${MODULE_DATA[0]}
		MODULE_PV=${MODULE_DATA[1]}
		if [[ $PV == "3.7.9999" ]]
		then
			S="${WORKDIR}/${MODULE_PN/calculate-/}-${MODULE_PV}"
		else
			S="${WORKDIR}/${MODULE_PN}-${MODULE_PV}"
		fi
		cd "$S"
		distutils-r1_src_install
	done
}

python_install() {
	PYTHON_INSTALL_PARAMS=
	if [[ $MODULE_PN == "calculate-client" ]]
	then
		PYTHON_INSTALL_PARAMS="--install-scripts=/usr/sbin"
	fi
	if [[ $MODULE_PN == "calculate-core" ]] && use dbus
	then
		PYTHON_INSTALL_PARAMS="$PYTHON_INSTALL_PARAMS --dbus"
	fi
	distutils-r1_python_install $PYTHON_INSTALL_PARAMS
}

calculate-utils-r18_pkg_preinst() {
	dosym /usr/libexec/calculate/cl-core-wrapper /usr/bin/cl-core-setup
	dosym /usr/libexec/calculate/cl-core-wrapper /usr/bin/cl-core-patch
	dosym /usr/libexec/calculate/cl-core-wrapper /usr/bin/cl-update
	dosym /usr/libexec/calculate/cl-core-wrapper /usr/bin/cl-update-profile
	dosym /usr/lib/python-exec/python3.12/cl-console /usr/bin/cl-console
	if use qt5
	then
		dosym /usr/lib/python-exec/python3.12/cl-console-gui /usr/bin/cl-console-gui
		dosym /usr/lib/python-exec/python3.12/cl-console-gui /usr/bin/cl-console-gui-install
		dosym /usr/lib/python-exec/python3.12/cl-console-gui /usr/bin/cl-console-gui-update
		dosym /usr/lib/python-exec/python3.12/cl-update-checker /usr/bin/cl-update-checker
	fi
}
