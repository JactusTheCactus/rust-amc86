#!/usr/bin/env bash
set -uo pipefail
source .env
dirs=(bin dist logs)
rm -rf "${dirs[@]}" compiler src/main.$NAME README.md
mkdir -p "${dirs[@]}"
declare -A scripts=(
	[src]=src/main.$NAME
	[llm]=README.md
)
for i in "${!scripts[@]}"; do
	"./$i.sh" > "${scripts[$i]}"
done
cmd=(
	'+nightly fmt'
	clippy
	build
)
for i in "${cmd[@]}"; do
	read -r -a args <<< "$i"
	cargo=(cargo "${args[@]}")
	if ! "${cargo[@]}" &> "logs/${args[-1]}.log"; then
		"${cargo[@]}"
		echo "${cargo[*]} failed"
		exit 1
	fi
done
find logs -empty -delete
ln -s target/debug/$NAME compiler
args=(
	-i src/main.amc86
	-o dist/main.asm
)
if (( $# > 0)); then
	args=("$@")
fi
./compiler "${args[@]}"
