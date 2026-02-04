#!/bin/bash

if [[ -n $netroot ]]
then
	cp -a /etc/resolv.conf ${NEWROOT}/etc/
fi
