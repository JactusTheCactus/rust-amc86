#!/usr/bin/env bash
set -uo pipefail
source src/sh/conf
cat << EOF
$(run def int i 0)
$(run def label start)
	$(run def str str Variable); $(run print var str) $(run comment Identical)
	$(run print Literal) $(run comment Identical '(Alias)')
	$(run incr i)
	$(run def bool loop "$(run le var i 10)"); $(run if "$(run var loop)" "$(run jump start)")
$(run exit 0)
EOF
