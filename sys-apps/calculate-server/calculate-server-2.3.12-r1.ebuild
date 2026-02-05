# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..13} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1

DESCRIPTION="Configuration utility for Linux services"
HOMEPAGE="https://www.calculate-linux.org/main/en/calculate2"
SRC_URI="https://git.calculate-linux.org/calculate/calculate-utils-2.1-server/archive/${PV}.tar.gz -> calculate-utils-2.1-server-${PV}.tar.gz"
S="${WORKDIR}/calculate-utils-2.1-server"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64"
IUSE="calculate_nomail
calculate_nodhcp
calculate_noftp
calculate_nojabber
calculate_nosamba
calculate_noproxy"

DEPEND="!sys-apps/calculate-lib
	acct-group/ldap
	acct-user/ldap
	>=net-nds/openldap-2.4[-minimal]
	>=sys-auth/pam_ldap-180[ssl]
	>=sys-auth/nss_ldap-239
	!<sys-apps/calculate-utils-3.5.0_alpha44
	!calculate_nosamba? (
		>=net-fs/samba-4[acl,client,cups,ldap,pam]
	)
	!calculate_nomail? (
		>=net-mail/dovecot-1.2.0[ldap,pam,ssl(+)]
		>=mail-filter/procmail-3.22
		|| ( dev-python/pymilter[${PYTHON_USEDEP}]
			dev-python/pymilter[${PYTHON_USEDEP}] )
		>=mail-mta/postfix-2.2[ldap,pam,ssl,sasl,dovecot-sasl]
	)
	!calculate_noftp? (
		>=net-ftp/proftpd-1.3.3[-acl,ident,ldap,ncurses,nls,pam,ssl]
	)
	!calculate_nojabber? (
		|| ( >=net-im/ejabberd-2.1.8[mod_pubsub,ldap]
			>=net-im/ejabberd-16.04-r1[ldap] )
		|| ( media-gfx/imagemagick
			media-gfx/graphicsmagick )
	)
	!calculate_noproxy? ( >=net-proxy/squid-3.0.14[ldap,pam,ssl] )
	!calculate_nodhcp? ( >=net-misc/dhcp-3.1.2_p1 )
	dev-python/python-ldap[ssl,${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
"
RDEPEND="${DEPEND}"

src_install() {
    local ret=0

    if declare -f python_install >/dev/null; then
            _distutils-r1_run_foreach_impl python_install || ret=${?}
    else
            _distutils-r1_run_foreach_impl distutils-r1_python_install || ret=${?}
    fi

    if declare -f python_install_all >/dev/null; then
            _distutils-r1_run_common_phase python_install_all || ret=${?}
    else
            _distutils-r1_run_common_phase distutils-r1_python_install_all || ret=${?}
    fi

    _distutils-r1_check_namespace_pth

    # now copy the extra directories outside the Python package tree
    insinto /usr/lib/calculate/calculate-server/pym
    doins -r "${S}/pym"/*

    insinto /usr/lib/calculate/calculate-server/ldif
    doins -r "${S}/ldif"/*

    insinto /usr/lib/calculate/calculate-server/profile
    doins -r "${S}/profile"/*

    insinto /usr/lib/calculate/calculate-server/bin
    doins -r "${S}/scripts"/*
}

pkg_postinst() {
	if [ -d /var/calculate/server-data/mail/imap ] || \
		[ -d /var/calculate/server-data/samba/win/profiles ] || \
		[ -d /var/calculate/server-data/samba/unix/profiles ] || \
		[ -d /var/calculate/server-data/samba/win/netlogon ];
	then
		ewarn "Data found in directories of previous version calculate-server"
	fi

	if [ -d /var/calculate/server-data/mail/imap ];
	then
		if ! [ -d /var/calculate/server-data/mail~ ];
		then
			if mv /var/calculate/server-data/mail/imap \
				/var/calculate/server-data/mail~ && \
				rmdir /var/calculate/server-data/mail && \
				mv /var/calculate/server-data/mail~ \
					/var/calculate/server-data/mail;
			then
				ewarn
				ewarn "Data from /var/calculate/server-data/mail/imap"
				ewarn "was moved to /var/calculate/server-data/mail"
				MAILUPDATE="TRUE"
			fi
		fi
		if ! [ "${MAILUPDATE}" == "TRUE" ];
		then
			eerror "Cannot move /var/calculate/server-data/mail/imap"
			eerror "Please manualy move /var/calculate/server-data/mail/imap"
			eerror "to /var/calculate/server-data/mail"
		fi
	fi

	if [ -d /var/calculate/server-data/samba/win/profiles ];
	then
		SAMBAUPDATE=""
		if ! [ -d /var/calculate/server-data/samba/profiles/win ];
		then
			if mkdir -p /var/calculate/server-data/samba/profiles && \
				mv  /var/calculate/server-data/samba/win/profiles \
					/var/calculate/server-data/samba/profiles/win;
			then
				ewarn
				ewarn "Data from /var/calculate/server-data/samba/win/profiles"
				ewarn "was moved to /var/calculate/server-data/samba/profiles/win"
				SAMBAUPDATE="TRUE"
			fi
		fi
		if ! [ "${SAMBAUPDATE}" == "TRUE" ];
		then
			eerror "Cannot move /var/calculate/server-data/samba/win/profiles"
			eerror "Please manualy move "
			eerror "/var/calculate/server-data/samba/win/profiles"
			eerror "to /var/calculate/server-data/samba/profiles/win"
		fi
	fi

	if [ -d /var/calculate/server-data/samba/unix/profiles ]; \
	then
		SAMBAUPDATE=""
		if ! [ -d /var/calculate/server-data/samba/profiles/unix ];
		then
			if mkdir -p /var/calculate/server-data/samba/profiles && \
				mv -f /var/calculate/server-data/samba/unix/profiles \
					/var/calculate/server-data/samba/profiles/unix;
			then
				rmdir /var/calculate/server-data/samba/unix
				ewarn
				ewarn "Data from /var/calculate/server-data/samba/unix/profiles"
				ewarn "was moved to /var/calculate/server-data/samba/profiles/unix"
				SAMBAUPDATE="TRUE"
			fi
		fi
		if ! [ "${SAMBAUPDATE}" == "TRUE" ];
		then
			eerror "Cannot move /var/calculate/server-data/samba/unix/profiles"
			eerror "Please manualy move "
			eerror "/var/calculate/server-data/samba/unix/profiles"
			eerror "to /var/calculate/server-data/samba/profiles/unix"
		fi
	fi

	if [ -d /var/calculate/server-data/samba/win/netlogon ];
	then
		SAMBAUPDATE=""
		if ! [ -d /var/calculate/server-data/samba/netlogon ];
		then
			if mv -f /var/calculate/server-data/samba/win/netlogon \
				/var/calculate/server-data/samba/netlogon;
			then
				rmdir /var/calculate/server-data/samba/win
				ewarn
				ewarn "Data form /var/calculate/server-data/samba/win/netlogon"
				ewarn "was moved to /var/calculate/server-data/samba/netlogon"
				SAMBAUPDATE="TRUE"
			fi
		fi
		if ! [ "${SAMBAUPDATE}" == "TRUE" ];
		then
			eerror "Cannot move /var/calculate/server-data/samba/win/netlogon"
			eerror "Please manualy move "
			eerror "/var/calculate/server-data/samba/win/netlogon"
			eerror "/var/calculate/server-data/samba/netlogon"
		fi
	fi

	if [ "${MAILUPDATE}" == "TRUE" ];
	then
	    ewarn
		ewarn "Please update mail service by the command:"
		ewarn "\tcl-update mail"
	fi
	if [ "${SAMBAUPDATE}" == "TRUE" ];
	then
	    ewarn
		ewarn "Please update samba service by the command:"
		ewarn "\tcl-update samba"
	fi

	ewarn
	ewarn "WARNING!!! If you have the samba service, then update it by the command:"
	ewarn "\tcl-update samba"
}
