#!/bin/bash
#
# world() - output the best stable package atom per slot in a portage category.
#
# For dev-python, only packages supporting the active Python target
# are included.
#
# Usage: world <category>
# Output: category/package:slot
#

set -euo pipefail

main() {
	local category=${1:-}

	if [[ -z "$category" ]]; then
		echo "Error! world(): category argument not specified." >&2
		exit 1
	fi

	if ! grep -qx "$category" "$(portageq get_repo_path / gentoo)/profiles/categories"; then
		echo "Error! world(): category '$category' not found." >&2
		exit 1
	fi

	if [[ "$category" == "dev-python" ]]; then
		local python_ver=$(portageq envvar USE | grep -oP 'python_single_target_python\K[0-9_]+')
		if [[ -z "$python_ver" ]]; then
			echo "Error! world(): failed to detect active python target version." >&2
			exit 1
		fi

		MY_SLOT='<category>/<name>:<slot>\n' \
		eix -C "$category" --stable \
			-\( \
				-U python_targets_python${python_ver} -o \
				-U python_single_target_python${python_ver} \
			-\) \
			--format '<bestslotversions:MY_SLOT>' '-*' || true
	else
		MY_SLOT='<category>/<name>:<slot>\n' \
		eix -C "$category" --stable \
			--format '<bestslotversions:MY_SLOT>' '-*' || true
	fi
}

main "$@"
