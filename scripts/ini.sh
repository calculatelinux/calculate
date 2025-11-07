declare -A ini

ini_repo_dirs(){
	declare -A repos_location
	import_repos_conf(){
		local repos_conf
		local conf_file=${1:-/etc/portage/repos.conf}
		if [[ -d $conf_file ]]; then
			repos_conf=$conf_file/*
		else
			repos_conf=$conf_file
		fi
		local sec
		while IFS= read -r line; do
			if [[ $line =~ ^[[:blank:]]*\[ ]]; then
				line=${line#*[}
				line=${line%%]*}
				sec=$line
				continue
			fi
			if [[ $line =~ ^[[:blank:]]*location ]]; then
				local val=${line#*=}
				val=${val#${val%%[![:space:]]*}} # remove leading whitespace characters
				val=${val%${val##*[![:space:]]}} # remove trailing whitespace characters
				repos_location[$sec]=$val
			fi
		done <<< "$(cat $repos_conf)"
	}
	get_list(){
		local path=$1
		local next
		if [[ -e $path/parent ]]; then
			while IFS= read -r line; do
				if [[ $line =~ ^[a-z0-9]+: ]]; then
					next=$(realpath ${repos_location[${line%%:*}]}/profiles/${line#*:})
				elif [[ ${line:0:1} == / ]]; then
					next=$(realpath $line)
				else
					next=$(realpath $path/$line)
				fi
				get_list $next
				echo $next
			done < $1/parent
		fi
	}
	import_repos_conf
	get_list $(realpath ${1:-/etc/portage/make.profile})
	echo $(realpath ${1:-/etc/portage/make.profile})
}

ini_list_files(){
	if [[ -z ${1:-} ]]; then
		[[ -n ${HOME:-} ]] && local home="$HOME/.calculate"
		local script_dir
		# Compute the script path only if the function is not called from a login shell
		if [[ ${0:0:1} != '-' ]]; then
			script_dir=$'\n'"$(dirname "$(readlink -f "$0")")"
		fi
		local default_path="/var/lib/calculate/calculate-update \
			${home:-} \
			/var/lib/calculate \
			/etc/calculate \
			/var/calculate \
			/var/calculate/remote${script_dir}"
	fi

	local path
	for path in $(ini_repo_dirs ${1:-}) ${default_path:-}; do
		if [[ -e $path/ini.env ]]; then
			echo $path/ini.env
		fi
	done
}

# The function reads values from all ini.env files into the ini array
ini_get(){
	ini=()
	local line sec ini_file
	for ini_file in $(ini_list_files ${1:-}); do
		while IFS= read -r line; do
		        if [[ $line =~ ^[[:blank:]]*\[ ]]; then
		                line=${line#*[}
		                line=${line%%]*}
		                sec=$line
		                continue
		        fi
			if [[ $line =~ ^[[:blank:]]*[#\;] || $line == '' ]]; then
				continue
			fi
			local var=${line%%=*}
			# remove leading whitespace characters
			var=${var#${var%%[![:space:]]*}}
			# remove trailing whitespace characters
			var=${var%${var##*[![:space:]]}}
			var=${sec}.${var}

			local val=${line#*=}
			# remove leading whitespace characters
			val=${val#${val%%[![:space:]]*}}
			# remove trailing whitespace characters
			val=${val%${val##*[![:space:]]}}
			ini[$var]=$val
		done < $ini_file
	done
}
