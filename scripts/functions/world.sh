#!/bin/bash
#
# world() - template function for Calculate Linux config templates.
#
# Runs `eix` against a given portage category and prints matching
# package atoms only (`-#`, --stable).
#
# For the "dev-python" category the search is additionally narrowed
# to packages that support the currently active python single/multi
# target USE flag (python_single_target_pythonX_Y /
# python_targets_pythonX_Y), detected from the current USE variable
# via portageq.
#
# Usage:
#   world <category>
#
# Arguments:
#   category - portage category name (e.g. "dev-python", "dev-libs")
#
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

	if [[ $category == "dev-python" ]]; then
		local python_ver=$(portageq envvar USE | grep -oP 'python_single_target_python\K[0-9_]+')
		if [[ -z "$python_ver" ]]; then
			echo "Error! world(): failed to detect active python target version." >&2
			exit 1
		fi

		eix -C "$category" --stable -# \
			-\( \
				-U python_targets_python${python_ver} -o \
				-U python_single_target_python${python_ver} \
			-\)
	else
		eix -C $category --stable -#
	fi
}

main "$@"
