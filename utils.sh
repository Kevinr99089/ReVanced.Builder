#!/usr/bin/env bash

MODULE_TEMPLATE_DIR="revanced-magisk"
<<<<<<< HEAD
CWD=$(pwd)
=======
>>>>>>> 71b9976 (Initial commit)
TEMP_DIR="temp"
BIN_DIR="bin"
BUILD_DIR="build"

if [ "${GITHUB_TOKEN-}" ]; then GH_HEADER="Authorization: token ${GITHUB_TOKEN}"; else GH_HEADER=; fi
NEXT_VER_CODE=${NEXT_VER_CODE:-$(date +'%Y%m%d')}
<<<<<<< HEAD
OS=$(uname -o)

toml_prep() {
	if [ ! -f "$1" ]; then return 1; fi
	if [ "${1##*.}" == toml ]; then
		__TOML__=$($TOML --output json --file "$1" .)
	elif [ "${1##*.}" == json ]; then
		__TOML__=$(cat "$1")
	else abort "config extension not supported"; fi
}
toml_get_table_names() { jq -r -e 'to_entries[] | select(.value | type == "object") | .key' <<<"$__TOML__"; }
toml_get_table_main() { jq -r -e 'to_entries | map(select(.value | type != "object")) | from_entries' <<<"$__TOML__"; }
toml_get_table() { jq -r -e ".\"${1}\"" <<<"$__TOML__"; }
toml_get() {
	local op
	op=$(jq -r ".\"${2}\" | values" <<<"$1")
	if [ "$op" ]; then
		op="${op#"${op%%[![:space:]]*}"}"
		op="${op%"${op##*[![:space:]]}"}"
		op=${op//"'"/'"'}
		echo "$op"
	else return 1; fi
}
=======
REBUILD=${REBUILD:-false}
OS=$(uname -o)

toml_prep() { __TOML__=$(tr -d '\t\r' <<<"$1" | tr "'" '"' | grep -o '^[^#]*' | grep -v '^$' | sed -r 's/(\".*\")|\s*/\1/g; 1i []'); }
toml_get_table_names() {
	local tn
	tn=$(grep -x '\[.*\]' <<<"$__TOML__" | tr -d '[]') || return 1
	if [ "$(sort <<<"$tn" | uniq -u | wc -l)" != "$(wc -l <<<"$tn")" ]; then
		abort "ERROR: Duplicate tables in TOML"
	fi
	echo "$tn"
}
toml_get_table() { sed -n "/\[${1}]/,/^\[.*]$/p" <<<"$__TOML__" | sed '${/^\[/d;}'; }
toml_get() {
	local table=$1 key=$2 val
	val=$(grep -m 1 "^${key}=" <<<"$table") && sed -e "s/^\"//; s/\"$//" <<<"${val#*=}"
}
# ---------------------------------------------------
>>>>>>> 71b9976 (Initial commit)

pr() { echo -e "\033[0;32m[+] ${1}\033[0m"; }
epr() {
	echo >&2 -e "\033[0;31m[-] ${1}\033[0m"
	if [ "${GITHUB_REPOSITORY-}" ]; then echo -e "::error::utils.sh [-] ${1}\n"; fi
}
abort() {
	epr "ABORT: ${1-}"
	exit 1
}

get_rv_prebuilts() {
<<<<<<< HEAD
	local cli_src=$1 cli_ver=$2 patches_src=$3 patches_ver=$4
	pr "Getting prebuilts (${patches_src%/*})" >&2
	local cl_dir=${patches_src%/*}
	cl_dir=${TEMP_DIR}/${cl_dir,,}-rv
	[ -d "$cl_dir" ] || mkdir "$cl_dir"
<<<<<<< HEAD
	for src_ver in "$cli_src CLI $cli_ver revanced-cli" "$patches_src Patches $patches_ver patches"; do
		set -- $src_ver
		local src=$1 tag=$2 ver=${3-} fprefix=$4
		local ext
		if [ "$tag" = "CLI" ]; then
			ext="jar"
		elif [ "$tag" = "Patches" ]; then
			ext="rvp"
=======
	local cli_src=$1 cli_ver=$2 integrations_src=$3 integrations_ver=$4 patches_src=$5 patches_ver=$6
	pr "Getting prebuilts (${patches_src%/*})" >&2
	for f in "${TEMP_DIR}"/*-rv; do : >"${f}/changelog.md"; done
=======
>>>>>>> 84016aa (build.sh and utils.sh updated)
	for src_ver in "$cli_src CLI $cli_ver" "$integrations_src Integrations $integrations_ver" "$patches_src Patches $patches_ver"; do
		set -- $src_ver
		local src=$1 tag=$2 ver=${3-} ext
		if [ "$tag" = "CLI" ] || [ "$tag" = "Patches" ]; then
			ext="jar"
		elif [ "$tag" = "Integrations" ]; then
			ext="apk"
>>>>>>> 71b9976 (Initial commit)
		else abort unreachable; fi
		local dir=${src%/*}
		dir=${TEMP_DIR}/${dir,,}-rv
		[ -d "$dir" ] || mkdir "$dir"

<<<<<<< HEAD
		local rv_rel="https://api.github.com/repos/${src}/releases" name_ver
		if [ "$ver" = "dev" ]; then
			name_ver="*-dev*"
		elif [ "$ver" = "latest" ]; then
			rv_rel+="/latest"
			name_ver="*"
		else
			rv_rel+="/tags/${ver}"
			name_ver="$ver"
		fi

		local url file tag_name name
<<<<<<< HEAD
		file=$(find "$dir" -name "${fprefix}-${name_ver#v}.${ext}" -type f 2>/dev/null)
=======
		file=$(find "$dir" -name "revanced-${tag,,}-${name_ver#v}.${ext}" -type f 2>/dev/null)
>>>>>>> 84016aa (build.sh and utils.sh updated)
		if [ -z "$file" ]; then
			local resp asset name
			resp=$(gh_req "$rv_rel" -) || return 1
			if [ "$ver" = "dev" ]; then resp=$(jq -r '.[0]' <<<"$resp"); fi
			tag_name=$(jq -r '.tag_name' <<<"$resp")
			asset=$(jq -e -r ".assets[] | select(.name | endswith(\"$ext\"))" <<<"$resp") || return 1
			url=$(jq -r .url <<<"$asset")
			name=$(jq -r .name <<<"$asset")
			file="${dir}/${name}"
			gh_dl "$file" "$url" >&2 || return 1
<<<<<<< HEAD
			echo "$tag: $(cut -d/ -f1 <<<"$src")/${name}  " >>"${cl_dir}/changelog.md"
		else
			local for_err=$file
			if [ "$ver" = "latest" ]; then
				file=$(grep -v '/[^/]*dev[^/]*$' <<<"$file" | head -1)
			else file=$(grep "/[^/]*${ver#v}[^/]*\$" <<<"$file" | head -1); fi
			if [ -z "$file" ]; then abort "filter fail: '$for_err' with '$ver'"; fi
			name=$(basename "$file")
			tag_name=$(cut -d'-' -f3- <<<"$name")
			tag_name=v${tag_name%.*}
=======
			if [ "$tag" = "Integrations" ]; then integs_file=$file; fi
			echo "$tag: $(cut -d/ -f1 <<<"$src")/${name}  " >>"${cl_dir}/changelog.md"
		else
			local for_err=$file
			if [ "$ver" = "latest" ]; then
				file=$(grep -v '/[^/]*dev[^/]*$' <<<"$file" | head -1)
			else file=$(grep "/[^/]*${ver#v}[^/]*\$" <<<"$file" | head -1); fi
			if [ -z "$file" ]; then abort "filter fail: '$for_err' with '$ver'"; fi
			name=$(basename "$file")
			tag_name=$(cut -d'-' -f3- <<<"$name")
			tag_name=v${tag_name%.*}
<<<<<<< HEAD
			if [ "$tag_name" = "v" ]; then abort "wrong ver"; fi
>>>>>>> 84016aa (build.sh and utils.sh updated)
=======
>>>>>>> 536d54c (build.sh and utils.sh updated)
		fi
		if [ "$tag" = "Patches" ]; then
			if [ ! -f "$file" ]; then echo -e "[Changelog](https://github.com/${src}/releases/tag/${tag_name})\n" >>"${cl_dir}/changelog.md"; fi
			if [ "$REMOVE_RV_INTEGRATIONS_CHECKS" = true ]; then
				if ! (
					mkdir -p "${file}-zip" || return 1
					unzip -qo "${file}" -d "${file}-zip" || return 1
					java -cp "${BIN_DIR}/paccer.jar:${BIN_DIR}/dexlib2.jar" com.jhc.Main "${file}-zip/extensions/shared.rve" "${file}-zip/extensions/shared-patched.rve" || return 1
					mv -f "${file}-zip/extensions/shared-patched.rve" "${file}-zip/extensions/shared.rve" || return 1
					rm "${file}" || return 1
					cd "${file}-zip" || abort
					zip -0rq "${CWD}/${file}" . || return 1
				) >&2; then
					echo >&2 "Patching revanced-integrations failed"
				fi
				rm -r "${file}-zip" || :
			fi
		fi
		echo -n "$file "
=======
		local rv_rel="https://api.github.com/repos/${src}/releases/"
		if [ "$ver" ]; then rv_rel+="tags/${ver}"; else rv_rel+="latest"; fi

<<<<<<< HEAD
		local resp asset url name file
		resp=$(gh_req "$rv_rel" -) || return 1
		asset=$(jq -e -r ".assets[] | select(.name | endswith(\"$ext\"))" <<<"$resp") || return 1
		url=$(jq -r .url <<<"$asset")
		name=$(jq -r .name <<<"$asset")
		file="${dir}/${name}"
		[ -f "$file" ] || REBUILD=true

		echo "$tag: $(cut -d/ -f5 <<<"$url")/${name}  " >>"$dir/changelog.md"
		gh_dl "$file" "$url" >&2 || return 1
=======
>>>>>>> 84016aa (build.sh and utils.sh updated)
		echo -n "$file "
		if [ "$tag" = "Patches" ]; then
			name="patches-${tag_name}.json"
			file="${dir}/${name}"
			if [ ! -f "$file" ]; then
				resp=$(gh_req "$rv_rel" -) || return 1
				if [ "$ver" = "dev" ]; then resp=$(jq -r '.[0]' <<<"$resp"); fi
				url=$(jq -e -r '.assets[] | select(.name | endswith("json")) | .url' <<<"$resp") || return 1
				gh_dl "$file" "$url" >&2 || return 1
				echo -e "[Changelog](https://github.com/${src}/releases/tag/${tag_name})\n" >>"${cl_dir}/changelog.md"
			fi
			echo -n "$file "
<<<<<<< HEAD
			echo -e "[Changelog](https://github.com/${src}/releases/tag/${tag_name})\n" >>"$dir/changelog.md"
=======
>>>>>>> 84016aa (build.sh and utils.sh updated)
		fi
>>>>>>> 71b9976 (Initial commit)
	done
	echo
<<<<<<< HEAD
=======

	if [ "$integs_file" ]; then
		if ! (
			mkdir -p "${integs_file}-zip" || return 1
			unzip -qo "${integs_file}" -d "${integs_file}-zip" || return 1
			cd "${integs_file}-zip" || return 1
			java -cp "${BIN_DIR}/paccer.jar:${BIN_DIR}/dexlib2.jar" com.jhc.Main "${integs_file}-zip/classes.dex" "${integs_file}-zip/classes-patched.dex" || return 1
			mv -f "${integs_file}-zip/classes-patched.dex" "${integs_file}-zip/classes.dex" || return 1
			rm "${integs_file}" || return 1
			zip -0rq "${integs_file}" . || return 1
		) >&2; then
			echo >&2 "Patching revanced-integrations failed"
		fi
		rm -r "${integs_file}-zip" || :

	fi
>>>>>>> 84016aa (build.sh and utils.sh updated)
}

<<<<<<< HEAD
set_prebuilts() {
=======
get_prebuilts() {
>>>>>>> 71b9976 (Initial commit)
	APKSIGNER="${BIN_DIR}/apksigner.jar"
	if [ "$OS" = Android ]; then
		local arch
		if [ "$(uname -m)" = aarch64 ]; then arch=arm64; else arch=arm; fi
		HTMLQ="${BIN_DIR}/htmlq/htmlq-${arch}"
		AAPT2="${BIN_DIR}/aapt2/aapt2-${arch}"
<<<<<<< HEAD
		TOML="${BIN_DIR}/toml/tq-${arch}"
	else
		HTMLQ="${BIN_DIR}/htmlq/htmlq-x86_64"
		TOML="${BIN_DIR}/toml/tq-x86_64"
	fi
}

config_update() {
	if [ ! -f build.md ]; then abort "build.md not available"; fi
	declare -A sources
	: >"$TEMP_DIR"/skipped
	local upped=()
=======
	else
		HTMLQ="${BIN_DIR}/htmlq/htmlq-x86_64"
	fi
	mkdir -p ${MODULE_TEMPLATE_DIR}/bin/arm64 ${MODULE_TEMPLATE_DIR}/bin/arm ${MODULE_TEMPLATE_DIR}/bin/x86 ${MODULE_TEMPLATE_DIR}/bin/x64
	gh_dl "${MODULE_TEMPLATE_DIR}/bin/arm64/cmpr" "https://github.com/j-hc/cmpr/releases/latest/download/cmpr-arm64-v8a"
	gh_dl "${MODULE_TEMPLATE_DIR}/bin/arm/cmpr" "https://github.com/j-hc/cmpr/releases/latest/download/cmpr-armeabi-v7a"
	gh_dl "${MODULE_TEMPLATE_DIR}/bin/x86/cmpr" "https://github.com/j-hc/cmpr/releases/latest/download/cmpr-x86"
	gh_dl "${MODULE_TEMPLATE_DIR}/bin/x64/cmpr" "https://github.com/j-hc/cmpr/releases/latest/download/cmpr-x86_64"
}

config_update() {
	declare -A sources
	: >"$TEMP_DIR"/skipped
	local conf=""
	# shellcheck disable=SC2154
	conf+=$(sed '1d' <<<"$main_config_t")
	conf+=$'\n'
>>>>>>> 71b9976 (Initial commit)
	local prcfg=false
	for table_name in $(toml_get_table_names); do
		if [ -z "$table_name" ]; then continue; fi
		t=$(toml_get_table "$table_name")
		enabled=$(toml_get "$t" enabled) || enabled=true
		if [ "$enabled" = false ]; then continue; fi
		PATCHES_SRC=$(toml_get "$t" patches-source) || PATCHES_SRC=$DEF_PATCHES_SRC
<<<<<<< HEAD
<<<<<<< HEAD
		PATCHES_VER=$(toml_get "$t" patches-version) || PATCHES_VER=$DEF_PATCHES_VER
		if [[ -v sources["$PATCHES_SRC/$PATCHES_VER"] ]]; then
			if [ "${sources["$PATCHES_SRC/$PATCHES_VER"]}" = 1 ]; then upped+=("$table_name"); fi
		else
			sources["$PATCHES_SRC/$PATCHES_VER"]=0
			local rv_rel="https://api.github.com/repos/${PATCHES_SRC}/releases"
			if [ "$PATCHES_VER" = "dev" ]; then
				last_patches=$(gh_req "$rv_rel" - | jq -e -r '.[0]')
			elif [ "$PATCHES_VER" = "latest" ]; then
				last_patches=$(gh_req "$rv_rel/latest" -)
			else
				last_patches=$(gh_req "$rv_rel/tags/${ver}" -)
			fi
			if ! last_patches=$(jq -e -r '.assets[] | select(.name | endswith("rvp")) | .name' <<<"$last_patches"); then
				abort oops
			fi
			if [ "$last_patches" ]; then
				if ! OP=$(grep "^Patches: ${PATCHES_SRC%%/*}/" build.md | grep "$last_patches"); then
					sources["$PATCHES_SRC/$PATCHES_VER"]=1
					prcfg=true
					upped+=("$table_name")
				else
					echo "$OP" >>"$TEMP_DIR"/skipped
=======
		if [[ -v sources[$PATCHES_SRC] ]]; then
			if [ "${sources[$PATCHES_SRC]}" = 1 ]; then
=======
		PATCHES_VER=$(toml_get "$t" patches-version) || PATCHES_VER=$DEF_PATCHES_VER
		if [[ -v sources["$PATCHES_SRC/$PATCHES_VER"] ]]; then
			if [ "${sources["$PATCHES_SRC/$PATCHES_VER"]}" = 1 ]; then
>>>>>>> 84016aa (build.sh and utils.sh updated)
				conf+="$t"
				conf+=$'\n'
			fi
		else
<<<<<<< HEAD
			sources[$PATCHES_SRC]=0
			if ! last_patches_url=$(gh_req "https://api.github.com/repos/${PATCHES_SRC}/releases/latest" - \
				| jq -e -r '.assets[] | select(.name | endswith("jar")) | .name'); then
				abort oops
			fi
			last_patches=${last_patches_url##*/}
			cur_patches=$(sed -n "s/.*Patches: ${PATCHES_SRC%%/*}\/\(.*\)/\1/p" build.md | xargs)
			if [ "$cur_patches" ] && [ "$last_patches" ]; then
				if [ "${cur_patches}" != "$last_patches" ]; then
					sources[$PATCHES_SRC]=1
=======
			sources["$PATCHES_SRC/$PATCHES_VER"]=0
			local rv_rel="https://api.github.com/repos/${PATCHES_SRC}/releases"
			if [ "$PATCHES_VER" = "dev" ]; then
				last_patches=$(gh_req "$rv_rel" - | jq -e -r '.[0]')
			elif [ "$PATCHES_VER" = "latest" ]; then
				last_patches=$(gh_req "$rv_rel/latest" -)
			else
				last_patches=$(gh_req "$rv_rel/tags/${ver}" -)
			fi

			if ! last_patches=$(jq -e -r '.assets[] | select(.name | endswith("jar")) | .name' <<<"$last_patches"); then
				abort oops
			fi
			if [ "$last_patches" ]; then
				if ! OP=$(grep "^Patches: ${PATCHES_SRC%%/*}/" build.md | grep "$last_patches"); then
					sources["$PATCHES_SRC/$PATCHES_VER"]=1
>>>>>>> 84016aa (build.sh and utils.sh updated)
					prcfg=true
					conf+="$t"
					conf+=$'\n'
				else
<<<<<<< HEAD
					echo "Patches: ${PATCHES_SRC%%/*}/${cur_patches}  " >>$TEMP_DIR/skipped
>>>>>>> 71b9976 (Initial commit)
=======
					echo "$OP" >>"$TEMP_DIR"/skipped
>>>>>>> 84016aa (build.sh and utils.sh updated)
				fi
			fi
		fi
	done
<<<<<<< HEAD
	if [ "$prcfg" = true ]; then
		local query=""
		for table in "${upped[@]}"; do
			if [ -n "$query" ]; then query+=" or "; fi
			query+=".key == \"$table\""
		done
		jq "to_entries | map(select(${query} or (.value | type != \"object\"))) | from_entries" <<<"$__TOML__"
	fi
=======
	if [ "$prcfg" = true ]; then echo "$conf"; fi
>>>>>>> 71b9976 (Initial commit)
}

_req() {
	local ip="$1" op="$2"
	shift 2
	if [ "$op" = - ]; then
		wget -nv -O "$op" "$@" "$ip"
	else
<<<<<<< HEAD
		if [ -f "$op" ]; then return; fi
=======
>>>>>>> 71b9976 (Initial commit)
		local dlp
		dlp="$(dirname "$op")/tmp.$(basename "$op")"
		if [ -f "$dlp" ]; then
			while [ -f "$dlp" ]; do sleep 1; done
			return
		fi
		wget -nv -O "$dlp" "$@" "$ip" || return 1
		mv -f "$dlp" "$op"
	fi
}
req() { _req "$1" "$2" --header="User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:108.0) Gecko/20100101 Firefox/108.0"; }
gh_req() { _req "$1" "$2" --header="$GH_HEADER"; }
gh_dl() {
	if [ ! -f "$1" ]; then
		pr "Getting '$1' from '$2'"
		_req "$2" "$1" --header="$GH_HEADER" --header="Accept: application/octet-stream"
	fi
}

log() { echo -e "$1  " >>"build.md"; }
<<<<<<< HEAD
get_highest_ver() {
=======
get_largest_ver() {
>>>>>>> 71b9976 (Initial commit)
	local vers m
	vers=$(tee)
	m=$(head -1 <<<"$vers")
	if ! semver_validate "$m"; then echo "$m"; else sort -rV <<<"$vers" | head -1; fi
}
semver_validate() {
	local a="${1%-*}"
	local ac="${a//[.0-9]/}"
	[ ${#ac} = 0 ]
}
get_patch_last_supported_ver() {
<<<<<<< HEAD
	local pkg_name=$1 inc_sel=$2 _exc_sel=$3 _exclusive=$4 # TODO: resolve using all of these
	local op
	if [ "$inc_sel" ]; then
		if ! op=$(java -jar "$rv_cli_jar" list-patches "$rv_patches_jar" -f "$pkg_name" -v -p 2>&1 | awk '{$1=$1}1'); then
			epr "list-patches: '$op'"
			return 1
		fi
		local ver vers="" NL=$'\n'
		while IFS= read -r line; do
			line="${line:1:${#line}-2}"
			ver=$(sed -n "/^Name: $line\$/,/^\$/p" <<<"$op" | sed -n "/^Compatible versions:\$/,/^\$/p" | tail -n +2)
			vers=${ver}${NL}
		done <<<"$(list_args "$inc_sel")"
		vers=$(awk '{$1=$1}1' <<<"$vers")
		if [ "$vers" ]; then
			get_highest_ver <<<"$vers"
			return
		fi
	fi
	if ! op=$(java -jar "$rv_cli_jar" list-versions "$rv_patches_jar" -f "$pkg_name" 2>&1 | tail -n +3 | awk '{$1=$1}1'); then
		epr "list-versions: '$op'"
		return 1
	fi
	if [ "$op" = "Any" ]; then return; fi
	pcount=$(head -1 <<<"$op") pcount=${pcount#*(} pcount=${pcount% *}
	if [ -z "$pcount" ]; then abort "unreachable: '$pcount'"; fi
	grep -F "($pcount patch" <<<"$op" | sed 's/ (.* patch.*//' | get_highest_ver || return 1
=======
	local inc_sel exc_sel vs
	inc_sel=$(list_args "$2" | sed 's/.*/\.name == &/' | paste -sd '~' | sed 's/~/ or /g' || :)
	exc_sel=$(list_args "$3" | sed 's/.*/\.name != &/' | paste -sd '~' | sed 's/~/ and /g' || :)
	inc_sel=${inc_sel:-false}
	if [ "$4" = false ]; then inc_sel="${inc_sel} or .use==true"; fi
	if ! vs=$(jq -e -r ".[]
			| select(.compatiblePackages // [] | .[] | .name==\"${1}\")
			| select(${inc_sel})
			| select(${exc_sel:-true})
			| .compatiblePackages[].versions // []" "$5"); then
		abort "error in jq query"
	fi
	tr -d ' ,\t[]"' <<<"$vs" | sort -u | grep -v '^$' | get_largest_ver || :
>>>>>>> 71b9976 (Initial commit)
}

isoneof() {
	local i=$1 v
	shift
	for v; do [ "$v" = "$i" ] && return 0; done
	return 1
}

<<<<<<< HEAD
merge_splits() {
	local bundle=$1 output=$2
	pr "Merging splits"
	gh_dl "$TEMP_DIR/apkeditor.jar" "https://github.com/REAndroid/APKEditor/releases/download/V1.3.9/APKEditor-1.3.9.jar" >/dev/null || return 1
	if ! OP=$(java -jar "$TEMP_DIR/apkeditor.jar" merge -i "${bundle}" -o "${bundle}.mzip" -clean-meta -f 2>&1); then
		epr "$OP"
		return 1
	fi
	# this is required because of apksig
	mkdir "${bundle}-zip"
	unzip -qo "${bundle}.mzip" -d "${bundle}-zip"
	pushd "${bundle}-zip" || abort
	zip -0rq "${CWD}/${bundle}.zip" .
	popd || abort
	# if building module, sign the merged apk properly
	if isoneof "module" "${build_mode_arr[@]}"; then
		patch_apk "${bundle}.zip" "${output}" "--exclusive" "${args[cli]}" "${args[ptjar]}"
		local ret=$?
	else
		cp "${bundle}.zip" "${output}"
		local ret=$?
	fi
	rm -r "${bundle}-zip" "${bundle}.zip" "${bundle}.mzip" || :
	return $ret
}

<<<<<<< HEAD
merge_splits() {
	local bundle=$1 output=$2
	pr "Merging splits"
	gh_dl "$TEMP_DIR/apkeditor.jar" "https://github.com/REAndroid/APKEditor/releases/download/V1.3.9/APKEditor-1.3.9.jar" >/dev/null || return 1
	if ! OP=$(java -jar "$TEMP_DIR/apkeditor.jar" merge -i "${bundle}" -o "${bundle}.mzip" -clean-meta -f 2>&1); then
		epr "$OP"
		return 1
	fi
	# this is required because of apksig
	mkdir "${bundle}-zip"
	unzip -qo "${bundle}.mzip" -d "${bundle}-zip"
	pushd "${bundle}-zip" || abort
	zip -0rq "${CWD}/${bundle}.zip" .
	popd || abort
	# if building module, sign the merged apk properly
	if isoneof "module" "${build_mode_arr[@]}"; then
		patch_apk "${bundle}.zip" "${output}" "--exclusive" "${args[cli]}" "${args[ptjar]}"
		local ret=$?
	else
		cp "${bundle}.zip" "${output}"
		local ret=$?
	fi
	rm -r "${bundle}-zip" "${bundle}.zip" "${bundle}.mzip" || :
	return $ret
}

# -------------------- apkmirror --------------------
apk_mirror_search() {
	local resp="$1" dpi="$2" arch="$3" apk_bundle="$4"
	local apparch dlurl node app_table
	if [ "$arch" = all ]; then
		apparch=(universal noarch 'arm64-v8a + armeabi-v7a')
	else apparch=("$arch" universal noarch 'arm64-v8a + armeabi-v7a'); fi
	for ((n = 1; n < 40; n++)); do
		node=$($HTMLQ "div.table-row.headerFont:nth-last-child($n)" -r "span:nth-child(n+3)" <<<"$resp")
		if [ -z "$node" ]; then break; fi
		app_table=$($HTMLQ --text --ignore-whitespace <<<"$node")
		if [ "$(sed -n 3p <<<"$app_table")" = "$apk_bundle" ] && [ "$(sed -n 6p <<<"$app_table")" = "$dpi" ] &&
			isoneof "$(sed -n 4p <<<"$app_table")" "${apparch[@]}"; then
			dlurl=$($HTMLQ --base https://www.apkmirror.com --attribute href "div:nth-child(1) > a:nth-child(1)" <<<"$node")
			echo "$dlurl"
			return 0
		fi
	done
	return 1
}
dl_apkmirror() {
	local url=$1 version=${2// /-} output=$3 arch=$4 dpi=$5 is_bundle=false
	if [ -f "${output}.apkm" ]; then
		is_bundle=true
	else
		if [ "$arch" = "arm-v7a" ]; then arch="armeabi-v7a"; fi
		local resp node app_table dlurl=""
		url="${url}/${url##*/}-${version//./-}-release/"
		resp=$(req "$url" -) || return 1
		node=$($HTMLQ "div.table-row.headerFont:nth-last-child(1)" -r "span:nth-child(n+3)" <<<"$resp")
		if [ "$node" ]; then
			if ! dlurl=$(apk_mirror_search "$resp" "$dpi" "${arch}" "APK"); then
				if ! dlurl=$(apk_mirror_search "$resp" "$dpi" "${arch}" "BUNDLE"); then
					return 1
				else is_bundle=true; fi
			fi
			[ -z "$dlurl" ] && return 1
			resp=$(req "$dlurl" -)
		fi
		url=$(echo "$resp" | $HTMLQ --base https://www.apkmirror.com --attribute href "a.btn") || return 1
		url=$(req "$url" - | $HTMLQ --base https://www.apkmirror.com --attribute href "span > a[rel = nofollow]") || return 1
	fi

	if [ "$is_bundle" = true ]; then
		req "$url" "${output}.apkm"
		merge_splits "${output}.apkm" "${output}"
	else
		req "$url" "${output}"
	fi
=======
# -------------------- apkmirror --------------------
dl_apkmirror() {
	local url=$1 version=${2// /-} output=$3 arch=$4 dpi=$5 apkorbundle=APK
	if [ "$arch" = "arm-v7a" ]; then arch="armeabi-v7a"; fi
	local apparch resp node app_table dlurl=""
	if [ "$arch" = all ]; then
		apparch=(universal noarch 'arm64-v8a + armeabi-v7a')
	else apparch=("$arch" universal noarch 'arm64-v8a + armeabi-v7a'); fi
	for ((n = 1; n < 40; n++)); do
		node=$($HTMLQ "div.table-row.headerFont:nth-last-child($n)" -r "span:nth-child(n+3)" <<<"$resp")
		if [ -z "$node" ]; then break; fi
		app_table=$($HTMLQ --text --ignore-whitespace <<<"$node")
		if [ "$(sed -n 3p <<<"$app_table")" = "$apk_bundle" ] && [ "$(sed -n 6p <<<"$app_table")" = "$dpi" ] &&
			isoneof "$(sed -n 4p <<<"$app_table")" "${apparch[@]}"; then
			dlurl=$($HTMLQ --base https://www.apkmirror.com --attribute href "div:nth-child(1) > a:nth-child(1)" <<<"$node")
			echo "$dlurl"
			return 0
		fi
	done
	return 1
}
dl_apkmirror() {
	local url=$1 version=${2// /-} output=$3 arch=$4 dpi=$5 is_bundle=false
	if [ "$arch" = "arm-v7a" ]; then arch="armeabi-v7a"; fi
	local resp node app_table dlurl=""
	url="${url}/${url##*/}-${version//./-}-release/"
	resp=$(req "$url" -) || return 1
	node=$($HTMLQ "div.table-row.headerFont:nth-last-child(1)" -r "span:nth-child(n+3)" <<<"$resp")
	if [ "$node" ]; then
		for ((n = 1; n < 40; n++)); do
			node=$($HTMLQ "div.table-row.headerFont:nth-last-child($n)" -r "span:nth-child(n+3)" <<<"$resp")
			if [ -z "$node" ]; then break; fi
			app_table=$($HTMLQ --text --ignore-whitespace <<<"$node")
			if [ "$(sed -n 3p <<<"$app_table")" = "$apkorbundle" ] && { [ "$apkorbundle" = BUNDLE ] \
				|| { [ "$apkorbundle" = APK ] && [ "$(sed -n 6p <<<"$app_table")" = "$dpi" ] \
					&& isoneof "$(sed -n 4p <<<"$app_table")" "${apparch[@]}"; }; }; then
				dlurl=$($HTMLQ --base https://www.apkmirror.com --attribute href "div:nth-child(1) > a:nth-child(1)" <<<"$node")
				break
			fi
		done
		[ -z "$dlurl" ] && return 1
		resp=$(req "$dlurl" -)
	fi
	url=$(echo "$resp" | $HTMLQ --base https://www.apkmirror.com --attribute href "a.btn") || return 1
	url=$(req "$url" - | $HTMLQ --base https://www.apkmirror.com --attribute href "span > a[rel = nofollow]") || return 1
	req "$url" "$output"
>>>>>>> 71b9976 (Initial commit)
}
get_apkmirror_vers() {
	local vers apkm_resp
	apkm_resp=$(req "https://www.apkmirror.com/uploads/?appcategory=${__APKMIRROR_CAT__}" -)
<<<<<<< HEAD
	vers=$(sed -n 's;.*Version:</span><span class="infoSlide-value">\(.*\) </span>.*;\1;p' <<<"$apkm_resp" | awk '{$1=$1}1')
=======
	vers=$(sed -n 's;.*Version:</span><span class="infoSlide-value">\(.*\) </span>.*;\1;p' <<<"$apkm_resp")
>>>>>>> 71b9976 (Initial commit)
	if [ "$__AAV__" = false ]; then
		local IFS=$'\n'
		vers=$(grep -iv "\(beta\|alpha\)" <<<"$vers")
		local v r_vers=()
		for v in $vers; do
			grep -iq "${v} \(beta\|alpha\)" <<<"$apkm_resp" || r_vers+=("$v")
		done
		echo "${r_vers[*]}"
	else
		echo "$vers"
	fi
}
get_apkmirror_pkg_name() { sed -n 's;.*id=\(.*\)" class="accent_color.*;\1;p' <<<"$__APKMIRROR_RESP__"; }
get_apkmirror_resp() {
	__APKMIRROR_RESP__=$(req "${1}" -)
	__APKMIRROR_CAT__="${1##*/}"
}
<<<<<<< HEAD
=======
# --------------------------------------------------
>>>>>>> 71b9976 (Initial commit)

# -------------------- uptodown --------------------
get_uptodown_resp() {
	__UPTODOWN_RESP__=$(req "${1}/versions" -)
	__UPTODOWN_RESP_PKG__=$(req "${1}/download" -)
}
get_uptodown_vers() { $HTMLQ --text ".version" <<<"$__UPTODOWN_RESP__"; }
dl_uptodown() {
<<<<<<< HEAD
	local uptodown_dlurl=$1 version=$2 output=$3 arch=$4 _dpi=$5
	if [ "$arch" = "arm-v7a" ]; then arch="armeabi-v7a"; fi
	local op resp data_code
	data_code=$($HTMLQ "#detail-app-name" --attribute data-code <<<"$__UPTODOWN_RESP__")
	local versionURL=""
	for i in {1..5}; do
		resp=$(req "${uptodown_dlurl}/apps/${data_code}/versions/${i}" -)
		if ! op=$(jq -e -r ".data | map(select(.version == \"${version}\" and .kindFile == \"apk\")) | .[0]" <<<"$resp"); then
			continue
		fi
		if versionURL=$(jq -e -r '.versionURL' <<<"$op"); then break; else return 1; fi
	done
	if [ -z "$versionURL" ]; then return 1; fi
	resp=$(req "$versionURL" -) || return 1
	if [ "$arch" != all ]; then
		local data_version files node_arch data_file_id
		data_version=$($HTMLQ '.button.variants' --attribute data-version <<<"$resp") || return 1
		files=$(req "${uptodown_dlurl%/*}/app/${data_code}/version/${data_version}/files" - | jq -e -r .content) || return 1
		for ((n = 1; n < 12; n += 2)); do
			node_arch=$($HTMLQ ".content > p:nth-child($n)" --text <<<"$files" | xargs) || return 1
			if [ -z "$node_arch" ]; then return 1; fi
			if [ "$node_arch" != "$arch" ]; then continue; fi
			data_file_id=$($HTMLQ "div.variant:nth-child($((n + 1))) > .v-report" --attribute data-file-id <<<"$files") || return 1
			resp=$(req "${uptodown_dlurl}/download/${data_file_id}" -)
			break
		done
	fi
	local data_url
	data_url=$($HTMLQ "#detail-download-button" --attribute data-url <<<"$resp") || return 1
	req "https://dw.uptodown.com/dwn/${data_url}" "$output"
}
get_uptodown_pkg_name() { $HTMLQ --text "tr.full:nth-child(1) > td:nth-child(3)" <<<"$__UPTODOWN_RESP_PKG__"; }

# -------------------- archive --------------------
=======
	local uptodown_dlurl=$1 version=$2 output=$3
	local url
	if [ "$is_latest" = false ]; then
		url=$(grep -F "${version}</span>" -B 2 <<<"$__UPTODOWN_RESP__" | head -1 | sed -n 's;.*data-url=".*download\/\(.*\)".*;\1;p') || return 1
		url="/$url"
	else url=""; fi
	if [ "$arch" != all ]; then
		local app_code data_version files node_arch content resp
		if [ "$is_latest" = false ]; then
			resp=$(req "${1}/download${url}" -)
		else resp="$__UPTODOWN_RESP_PKG__"; fi
		app_code=$($HTMLQ "#detail-app-name" --attribute code <<<"$resp")
		data_version=$($HTMLQ "button.button:nth-child(2)" --attribute data-version <<<"$resp")
		files=$(req "${uptodown_dlurl%/*}/app/${app_code}/version/${data_version}/files" - | jq -r .content)
		for ((n = 1; n < 40; n++)); do
			node_arch=$($HTMLQ ".content > p:nth-child($n)" --text <<<"$files" | xargs) || return 1
			if [ -z "$node_arch" ]; then return 1; fi
			if [ "$node_arch" != "$arch" ]; then continue; fi
			content=$($HTMLQ "div.variant:nth-child($((n + 1)))" <<<"$files")
			url=$(sed -n "s;.*'.*android\/post-download\/\(.*\)'.*;\1;p" <<<"$content" | head -1)
			url="/$url"
			break
		done
	fi
	url="https://dw.uptodown.com/dwn/$(req "${uptodown_dlurl}/post-download${url}" - | sed -n 's;.*class="post-download" data-url="\(.*\)".*;\1;p')" || return 1
	req "$url" "$output"
}
get_uptodown_pkg_name() { $HTMLQ --text "tr.full:nth-child(1) > td:nth-child(3)" <<<"$__UPTODOWN_RESP_PKG__"; }

# -------------------- apkmonk ---------------------
get_apkmonk_resp() {
	__APKMONK_RESP__=$(req "${1}" -)
	__APKMONK_PKG_NAME__=$(awk -F/ '{print $NF}' <<<"$1")
}
get_apkmonk_vers() { grep -oP 'download_ver.+?>\K([0-9,\.]*)' <<<"$__APKMONK_RESP__"; }
dl_apkmonk() {
	local url=$1 version=$2 output=$3
	url="https://www.apkmonk.com/down_file?pkg="$(grep -F "$version</a>" <<<"$__APKMONK_RESP__" | grep -oP 'href=\"/download-app/\K.+?(?=/?\">)' | sed 's;/;\&key=;') || return 1
	url=$(req "$url" - | grep -oP 'https.+?(?=\",)') || return 1
	req "$url" "$output"
}
get_apkmonk_pkg_name() { echo "$__APKMONK_PKG_NAME__"; }
# --------------------------------------------------
>>>>>>> 71b9976 (Initial commit)
dl_archive() {
	local url=$1 version=$2 output=$3 arch=$4
	local path version=${version// /}
	path=$(grep "${version_f#v}-${arch// /}" <<<"$__ARCHIVE_RESP__") || return 1
	req "${url}/${path}" "$output"
}
get_archive_resp() {
	local r
	r=$(req "$1" -)
	if [ -z "$r" ]; then return 1; else __ARCHIVE_RESP__=$(sed -n 's;^<a href="\(.*\)"[^"]*;\1;p' <<<"$r"); fi
	__ARCHIVE_PKG_NAME__=$(awk -F/ '{print $NF}' <<<"$1")
}
get_archive_vers() { sed 's/^[^-]*-//;s/-\(all\|arm64-v8a\|arm-v7a\)\.apk//g' <<<"$__ARCHIVE_RESP__"; }
get_archive_pkg_name() { echo "$__ARCHIVE_PKG_NAME__"; }
# --------------------------------------------------

patch_apk() {
	local stock_input=$1 patched_apk=$2 patcher_args=$3 rv_cli_jar=$4 rv_patches_jar=$5
<<<<<<< HEAD
	local cmd="java -jar $rv_cli_jar patch $stock_input --purge -o $patched_apk -p $rv_patches_jar --keystore=ks.keystore \
--keystore-entry-password=123456789 --keystore-password=123456789 --signer=jhc --keystore-entry-alias=jhc $patcher_args"
	if [ "$OS" = Android ]; then cmd+=" --custom-aapt2-binary=${AAPT2}"; fi
	pr "$cmd"
	if eval "$cmd"; then [ -f "$patched_apk" ]; else
		rm "$patched_apk" 2>/dev/null || :
		return 1
	fi
=======
	local cmd="java -jar $rv_cli_jar patch $stock_input -p -o $patched_apk -b $rv_patches_jar  $patcher_args --keystore=ks.keystore \
--keystore-entry-password=123456789 --keystore-password=123456789 --signer=jhc --keystore-entry-alias=jhc --options=options.json"
	if [ "$OS" = Android ]; then cmd+=" --custom-aapt2-binary=${AAPT2}"; fi
	pr "$cmd"
	eval "$cmd"
	[ -f "$patched_apk" ]
>>>>>>> 71b9976 (Initial commit)
}

check_sig() {
	local file=$1 pkg_name=$2
	local sig
	if grep -q "$pkg_name" sig.txt; then
		sig=$(java -jar "$APKSIGNER" verify --print-certs "$file" | grep ^Signer | grep SHA-256 | tail -1 | awk '{print $NF}')
		grep -qFx "$sig $pkg_name" sig.txt
	fi
}

build_rv() {
	eval "declare -A args=${1#*=}"
<<<<<<< HEAD
	local version="" pkg_name=""
=======
	local version build_mode_arr pkg_name
>>>>>>> 71b9976 (Initial commit)
	local mode_arg=${args[build_mode]} version_mode=${args[version]}
	local app_name=${args[app_name]}
	local app_name_l=${app_name,,}
	app_name_l=${app_name_l// /-}
	local table=${args[table]}
	local dl_from=${args[dl_from]}
	local arch=${args[arch]}
	local arch_f="${arch// /}"

	local p_patcher_args=()
<<<<<<< HEAD
	if [ "${args[excluded_patches]}" ]; then p_patcher_args+=("$(join_args "${args[excluded_patches]}" -d)"); fi
	if [ "${args[included_patches]}" ]; then p_patcher_args+=("$(join_args "${args[included_patches]}" -e)"); fi
	[ "${args[exclusive_patches]}" = true ] && p_patcher_args+=("--exclusive")

	local tried_dl=()
	for dl_p in archive apkmirror uptodown; do
		if [ -z "${args[${dl_p}_dlurl]}" ]; then continue; fi
		if ! get_${dl_p}_resp "${args[${dl_p}_dlurl]}" || ! pkg_name=$(get_"${dl_p}"_pkg_name); then
=======
	p_patcher_args+=("$(join_args "${args[excluded_patches]}" -e) $(join_args "${args[included_patches]}" -i)")
	[ "${args[exclusive_patches]}" = true ] && p_patcher_args+=("--exclusive")

	local tried_dl=()
	for dl_p in archive apkmirror uptodown; do
		if [ -z "${args[${dl_p}_dlurl]}" ]; then continue; fi
		if ! get_"${dl_p}"_resp "${args[${dl_p}_dlurl]}" || ! pkg_name=$(get_"${dl_p}"_pkg_name); then
>>>>>>> 71b9976 (Initial commit)
			args[${dl_p}_dlurl]=""
			epr "ERROR: Could not find ${table} in ${dl_p}"
			continue
		fi
<<<<<<< HEAD
		tried_dl+=("$dl_p")
=======
>>>>>>> 71b9976 (Initial commit)
		dl_from=$dl_p
		break
	done
	if [ -z "$pkg_name" ]; then
		epr "empty pkg name, not building ${table}."
		return 0
	fi
	local get_latest_ver=false
	if [ "$version_mode" = auto ]; then
		if ! version=$(get_patch_last_supported_ver "$pkg_name" \
<<<<<<< HEAD
			"${args[included_patches]}" "${args[excluded_patches]}" "${args[exclusive_patches]}"); then
=======
			"${args[included_patches]}" "${args[excluded_patches]}" "${args[exclusive_patches]}" "${args[ptjs]}"); then
>>>>>>> 71b9976 (Initial commit)
			exit 1
		elif [ -z "$version" ]; then get_latest_ver=true; fi
	elif isoneof "$version_mode" latest beta; then
		get_latest_ver=true
		p_patcher_args+=("-f")
	else
		version=$version_mode
		p_patcher_args+=("-f")
	fi
	if [ $get_latest_ver = true ]; then
		if [ "$version_mode" = beta ]; then __AAV__="true"; else __AAV__="false"; fi
		pkgvers=$(get_"${dl_from}"_vers)
<<<<<<< HEAD
		version=$(get_highest_ver <<<"$pkgvers") || version=$(head -1 <<<"$pkgvers")
=======
		version=$(get_largest_ver <<<"$pkgvers") || version=$(head -1 <<<"$pkgvers")
>>>>>>> 71b9976 (Initial commit)
	fi
	if [ -z "$version" ]; then
		epr "empty version, not building ${table}."
		return 0
	fi
<<<<<<< HEAD

	if [ "$mode_arg" = module ]; then
		build_mode_arr=(module)
	elif [ "$mode_arg" = apk ]; then
		build_mode_arr=(apk)
	elif [ "$mode_arg" = both ]; then
		build_mode_arr=(apk module)
	fi

=======
>>>>>>> 71b9976 (Initial commit)
	pr "Choosing version '${version}' for ${table}"
	local version_f=${version// /}
	version_f=${version_f#v}
	local stock_apk="${TEMP_DIR}/${pkg_name}-${version_f}-${arch_f}.apk"
	if [ ! -f "$stock_apk" ]; then
<<<<<<< HEAD
		for dl_p in archive apkmirror uptodown; do
			if [ -z "${args[${dl_p}_dlurl]}" ]; then continue; fi
			pr "Downloading '${table}' from ${dl_p}"
			if ! isoneof $dl_p "${tried_dl[@]}"; then get_${dl_p}_resp "${args[${dl_p}_dlurl]}"; fi
			if ! dl_${dl_p} "${args[${dl_p}_dlurl]}" "$version" "$stock_apk" "$arch" "${args[dpi]}" "$get_latest_ver"; then
=======
		for dl_p in archive apkmirror uptodown apkmonk; do
			if [ -z "${args[${dl_p}_dlurl]}" ]; then continue; fi
			pr "Downloading '${table}' from ${dl_p}"
			if ! dl_${dl_p} "${args[${dl_p}_dlurl]}" "$version" "$stock_apk" "$arch" "${args[dpi]}"; then
>>>>>>> 71b9976 (Initial commit)
				epr "ERROR: Could not download '${table}' from ${dl_p} with version '${version}', arch '${arch}', dpi '${args[dpi]}'"
				continue
			fi
			break
		done
		if [ ! -f "$stock_apk" ]; then return 0; fi
	fi
	if ! check_sig "$stock_apk" "$pkg_name"; then
		abort "apk signature mismatch '$stock_apk'"
	fi
	log "${table}: ${version}"

<<<<<<< HEAD
	local microg_patch
	microg_patch=$(java -jar "$rv_cli_jar" list-patches "$rv_patches_jar" -f "$pkg_name" -v -p 2>&1 |
		grep "^Name: " | grep -i "gmscore\|microg" || :) microg_patch=${microg_patch#*: }
=======
	p_patcher_args+=("-m ${args[integ]}")
	local microg_patch
	microg_patch=$(jq -r ".[] | select(.compatiblePackages // [] | .[] | .name==\"${pkg_name}\") | .name" "${args[ptjs]}" | grep -i "gmscore\|microg" || :)
>>>>>>> 71b9976 (Initial commit)
	if [ -n "$microg_patch" ] && [[ ${p_patcher_args[*]} =~ $microg_patch ]]; then
		epr "You cant include/exclude microg patches as that's done by rvmm builder automatically."
		p_patcher_args=("${p_patcher_args[@]//-[ei] ${microg_patch}/}")
	fi

<<<<<<< HEAD
	local patcher_args patched_apk build_mode
	local rv_brand_f=${args[rv_brand],,}
	rv_brand_f=${rv_brand_f// /-}
	if [ "${args[patcher_args]}" ]; then p_patcher_args+=("${args[patcher_args]}"); fi
=======
	if [ "$mode_arg" = module ]; then
		build_mode_arr=(module)
	elif [ "$mode_arg" = apk ]; then
		build_mode_arr=(apk)
	elif [ "$mode_arg" = both ]; then
		build_mode_arr=(apk module)
	fi
	local patcher_args patched_apk build_mode
	local rv_brand_f=${args[rv_brand],,}
	rv_brand_f=${rv_brand_f// /-}
>>>>>>> 71b9976 (Initial commit)
	for build_mode in "${build_mode_arr[@]}"; do
		patcher_args=("${p_patcher_args[@]}")
		pr "Building '${table}' in '$build_mode' mode"
		if [ -n "$microg_patch" ]; then
			patched_apk="${TEMP_DIR}/${app_name_l}-${rv_brand_f}-${version_f}-${arch_f}-${build_mode}.apk"
			if [ "$build_mode" = apk ]; then
<<<<<<< HEAD
				patcher_args+=("-e \"${microg_patch}\"")
			elif [ "$build_mode" = module ]; then
				patcher_args+=("-d \"${microg_patch}\"")
=======
				patcher_args+=("-i \"${microg_patch}\"")
			elif [ "$build_mode" = module ]; then
				patcher_args+=("-e \"${microg_patch}\"")
>>>>>>> 71b9976 (Initial commit)
			fi
		else
			patched_apk="${TEMP_DIR}/${app_name_l}-${rv_brand_f}-${version_f}-${arch_f}.apk"
		fi
		if [ "${args[riplib]}" = true ]; then
			patcher_args+=("--rip-lib x86_64 --rip-lib x86")
			if [ "$build_mode" = module ]; then
				patcher_args+=("--rip-lib arm64-v8a --rip-lib armeabi-v7a --unsigned")
			else
				if [ "$arch" = "arm64-v8a" ]; then
					patcher_args+=("--rip-lib armeabi-v7a")
				elif [ "$arch" = "arm-v7a" ]; then
					patcher_args+=("--rip-lib arm64-v8a")
				fi
<<<<<<< HEAD
			fi
		fi
		if [ "${NORB:-}" != true ] || [ ! -f "$patched_apk" ]; then
<<<<<<< HEAD
=======

			fi
		fi
		if [ ! -f "$patched_apk" ] || [ "$REBUILD" = true ]; then
>>>>>>> 71b9976 (Initial commit)
=======
>>>>>>> 536d54c (build.sh and utils.sh updated)
			if ! patch_apk "$stock_apk" "$patched_apk" "${patcher_args[*]}" "${args[cli]}" "${args[ptjar]}"; then
				epr "Building '${table}' failed!"
				return 0
			fi
		fi
		if [ "$build_mode" = apk ]; then
			local apk_output="${BUILD_DIR}/${app_name_l}-${rv_brand_f}-v${version_f}-${arch_f}.apk"
<<<<<<< HEAD
			mv -f "$patched_apk" "$apk_output"
=======
			cp -f "$patched_apk" "$apk_output"
>>>>>>> 71b9976 (Initial commit)
			pr "Built ${table} (non-root): '${apk_output}'"
			continue
		fi
		local base_template
<<<<<<< HEAD
		base_template=$(mktemp -d -p "$TEMP_DIR")
=======
		base_template=$(mktemp -d -p $TEMP_DIR)
>>>>>>> 71b9976 (Initial commit)
		cp -a $MODULE_TEMPLATE_DIR/. "$base_template"
		local upj="${table,,}-update.json"

		module_config "$base_template" "$pkg_name" "$version" "$arch"
		module_prop \
			"${args[module_prop_name]}" \
			"${app_name} ${args[rv_brand]}" \
			"$version" \
			"${app_name} ${args[rv_brand]} Magisk module" \
			"https://raw.githubusercontent.com/${GITHUB_REPOSITORY-}/update/${upj}" \
			"$base_template"

		local module_output="${app_name_l}-${rv_brand_f}-magisk-v${version_f}-${arch_f}.zip"
<<<<<<< HEAD
		pr "Packing module ${table}"
		cp -f "$patched_apk" "${base_template}/base.apk"
		if [ "${args[include_stock]}" = true ]; then cp -f "$stock_apk" "${base_template}/${pkg_name}.apk"; fi
		pushd >/dev/null "$base_template" || abort "Module template dir not found"
		zip -"$COMPRESSION_LEVEL" -FSqr "${CWD}/${BUILD_DIR}/${module_output}" .
		popd >/dev/null || :
=======
		if [ ! -f "$module_output" ] || [ "$REBUILD" = true ]; then
			pr "Packing module ${table}"
			cp -f "$patched_apk" "${base_template}/base.apk"
			if [ "${args[include_stock]}" = true ]; then cp -f "$stock_apk" "${base_template}/${pkg_name}.apk"; fi
			pushd >/dev/null "$base_template" || abort "Module template dir not found"
			zip -"$COMPRESSION_LEVEL" -FSqr "../../${BUILD_DIR}/${module_output}" .
			popd >/dev/null || :
		fi
>>>>>>> 71b9976 (Initial commit)
		pr "Built ${table} (root): '${BUILD_DIR}/${module_output}'"
	done
}

list_args() { tr -d '\t\r' <<<"$1" | tr -s ' ' | sed 's/" "/"\n"/g' | sed 's/\([^"]\)"\([^"]\)/\1'\''\2/g' | grep -v '^$' || :; }
join_args() { list_args "$1" | sed "s/^/${2} /" | paste -sd " " - || :; }

module_config() {
	local ma=""
	if [ "$4" = "arm64-v8a" ]; then
		ma="arm64"
	elif [ "$4" = "arm-v7a" ]; then
		ma="arm"
	fi
	echo "PKG_NAME=$2
PKG_VER=$3
MODULE_ARCH=$ma" >"$1/config"
}
module_prop() {
	echo "id=${1}
name=${2}
<<<<<<< HEAD
version=v${3} (${NEXT_VER_CODE})
=======
version=v${3}
>>>>>>> 71b9976 (Initial commit)
versionCode=${NEXT_VER_CODE}
author=j-hc
description=${4}" >"${6}/module.prop"

	if [ "$ENABLE_MAGISK_UPDATE" = true ]; then echo "updateJson=${5}" >>"${6}/module.prop"; fi
}
