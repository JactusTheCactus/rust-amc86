#!/usr/bin/env bash
set -uo pipefail
ignore=(
	build
	deps
	incremental
	\*.{d,rlib}
	flycheck0
	CACHEDIR.TAG
)
args=(
	"${PWD##*/}"
	--noreport
	--prune
	--dirsfirst
	-F
)
for i in "${ignore[@]}"; do
	args+=(-I "$i")
done
cd ..
tree "${args[@]}"
