#!/bin/bash
#
# world() - outputs the best stable package atom for each slot
# in the specified portage category.
#
# If a package has the python_targets_python<ver> or
# python_single_target_python<ver> USE flags, it is included only
# if the active python version is supported.  If a package has
# php_targets_php<m-m> USE flags, it is included only if one of
# the active PHP targets (PHP_TARGETS) is supported.
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
		if ! grep -qx "$category" "$("${chroot_cmd[@]}" portageq get_repo_path / gentoo)/profiles/categories"; then
			echo "Error! world(): category '$category' not found." >&2
			exit 1
		fi

		local python_ver
		python_ver=$("${chroot_cmd[@]}" portageq envvar USE | grep -oP 'python_single_target_python\K[0-9_]+')
		if [[ -z "$python_ver" ]]; then
			echo "Error! world(): failed to detect active python target version." >&2
			exit 1
		fi

		# Active PHP targets are taken from PHP_TARGETS first, falling
		# back to the expanded php_targets_* flags in USE.  With no
		# active target, packages requiring one are excluded.
		local -a php_tgts=()
		mapfile -t php_tgts < <("${chroot_cmd[@]}" portageq envvar PHP_TARGETS \
			| tr ' ' '\n' | grep -xE 'php[0-9]+-[0-9]+' | sort -u)
		if [[ ${#php_tgts[@]} -eq 0 ]]; then
			mapfile -t php_tgts < <("${chroot_cmd[@]}" portageq envvar USE \
				| tr ' ' '\n' | grep -oP '^php_targets_\Kphp[0-9]+-[0-9]+' | sort -u)
		fi

		local -a php_filter=('-!' -U 'php_targets_.*')
		if [[ ${#php_tgts[@]} -gt 0 ]]; then
			local php_alt
			php_alt=$(IFS='|'; echo "${php_tgts[*]}")
			php_filter=('-(' '-!' -U 'php_targets_.*' -o -U "php_targets_(${php_alt})\$" '-)')
		fi

		"${chroot_cmd[@]}" env MY_SLOT='<category>/<name>:<slot>\n' \
		eix -C "$category" --stable --format '<bestslotversions:MY_SLOT>' '-*' \
			'-(' \
				'-!' -U "python_(targets|single_target)_python.*" \
				-o \
				-U "python_(targets|single_target)_python${python_ver}\$" \
			'-)' \
			"${php_filter[@]}" || true
	else
		"${chroot_cmd[@]}" env MY_SLOT='<category>/<name>:<slot>\n' \
		eix -e "$category" --stable --format '<bestslotversions:MY_SLOT>' '-*' || true
	fi
}

main "$@"
