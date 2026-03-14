#!/usr/bin/env bash
set -uo pipefail
flag() {
	for f in "$@"
		do [[ -e ".flags/$f" ]] || return 1
	done
}
if flag local
	then :
	else :
fi
