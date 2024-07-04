
# vim: set syntax=sh
#
# Copyright 2024 Calculate Ltd. http://www.calculate-linux.org
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0

PROFILE_BASHRC_DIRS=(
	/etc/calculate/profile.bashrc.d
	/var/lib/calculate/profile.bashrc.d
)

for PROFILE_BASHRC_FILE in $((for dn in ${PROFILE_BASHRC_DIRS[@]}; do ls -1 $dn 2>/dev/null; done) | sort -u); do
    for PROFILE_BASHRC_DN in ${PROFILE_BASHRC_DIRS[@]}; do
        if [[ -f ${PROFILE_BASHRC_DN}/${PROFILE_BASHRC_FILE} ]]; then
            source ${PROFILE_BASHRC_DN}/${PROFILE_BASHRC_FILE}
            break
        fi
    done
done
