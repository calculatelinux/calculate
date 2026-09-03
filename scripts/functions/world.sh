#!/bin/bash
#
# world() - outputs the best stable package atom for each slot
# in the specified portage category.
#
# If a package has the python_targets_python<ver> or
# python_single_target_python<ver> USE flags, it is included only
# if the active python version is supported.
#
# Usage: world <category|category/package>
# Output: category/package:slot (one line per slot)

set -euo pipefail

main() {
	local category=${1:-}

	if [[ -z "$category" ]]; then
		echo "Error! world(): category argument not specified." >&2
		exit 1
	fi

	local -a chroot_cmd=()
	if [[ "#-cl_chroot_status-#" == "on" ]]; then
		chroot_cmd=(chroot "#-cl_chroot_path-#")
	fi

	if [[ ! "$category" =~ / ]]; then
		if ! grep -qx "$category" "$(portageq get_repo_path / gentoo)/profiles/categories"; then
			echo "Error! world(): category '$category' not found." >&2
			exit 1
		fi

		local python_ver
		python_ver=$(portageq envvar USE | grep -oP 'python_single_target_python\K[0-9_]+')
		if [[ -z "$python_ver" ]]; then
			echo "Error! world(): failed to detect active python target version." >&2
			exit 1
		fi

		"${chroot_cmd[@]}" env MY_SLOT='<category>/<name>:<slot>\n' \
		eix -C "$category" --stable \
			-\( \
				-\! -U "python_(targets|single_target)_python" \
				-o \
				-\( \
					-U "python_targets_python${python_ver}" -o \
					-U "python_single_target_python${python_ver}" \
				-\) \
			-\) \
			--format '<bestslotversions:MY_SLOT>' '-*' || true
	else
		"${chroot_cmd[@]}" env MY_SLOT='<category>/<name>:<slot>\n' \
		eix -e "$category" --stable \
			--format '<bestslotversions:MY_SLOT>' '-*' || true
	fi
}

main "$@"
