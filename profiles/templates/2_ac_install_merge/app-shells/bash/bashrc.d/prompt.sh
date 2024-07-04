# Calculate comment=#
#!/bin/bash

if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

if ${use_color} ; then
	PS_HOSTNAME=$(timeout 1.5 hostname -f 2>/dev/null)
	if [[ $PS_HOSTNAME ]]
	then
		PS_HOSTNAME=${PS_HOSTNAME%.*}
		PS_HOSTNAME=${PS_HOSTNAME%.*}
	else
		PS_HOSTNAME="$(hostname)"
	fi
	if [[ ${EUID} == 0 ]] ; then
#?in(os_linux_pkglist,container)==#
		PS1='\[\033[01;31m\]${PS_HOSTNAME}\[\033[01;34m\] \W \$\[\033[00m\] '
#!in#
		PS1='\[\033[00;33m\]${PS_HOSTNAME}\[\033[01;34m\] \W \$\[\033[00m\] '
#in#
	else
		PS1='\[\033[01;32m\]\u@${PS_HOSTNAME}\[\033[01;34m\] \w \$\[\033[00m\] '
	fi
fi
