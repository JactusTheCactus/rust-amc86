#!/usr/bin/env bash
set -uo pipefail
source .env
# echo "What's a good way to implement a simple, line-based (Split lines on \`;\` before processing), language (let's call it \`${NAME^^}\` (file-type: \`*.${NAME%86}[86]\`)), in Rust, that compiles with \`nasm\` (don't just write it for me)?"
printf '# Example\n```%s\n%s\n```\n' \
	"$NAME" \
	"$(cat "src/main.$NAME")"
declare -A syntax=(
	["def TYPE ${VAR}V [EXPR...]"]="Declare a variable (\`V\`) and assign it to the value of \`EXPR\`. Valid types include; $(
		declare -A types=(
			[int]='64-bit signed integer'
			[str]=''
			[bool]='identical to 0 or 1'
		)
		while read -r k; do
			v=${types[$k]}
			printf '`%s[%s]`' "${k:0:1}" "${k:1}"
			if [[ -n "$v" ]]; then
				printf ' (%s)' "$v"
			fi
			printf ', '
		done < <(printf '%s\n' "${!types[@]}" | sort) | perl -pe 's|,\s*$||g'
	)"
	["print [${VAR}]V:s"]='Write the value of `V` to standard output. If `V` is not a defined variable, it will be defined first.'
	["incr ${VAR}I:i"]='increment `I` by 1'
	["if [${VAR}]C:b E..."]='Evaluates `E` if `C` is a true boolean'
	["exit [$VAR]C:i"]='Terminates the program with `C` as the exit code'
	["${VAR}variable"]="All variables are prefixed by a \`$VAR\`"
	["$COMMENT comment"]="A \`$COMMENT\` denotes the start of a comment. The rest of the line is not seen by the compiler"
	["label ${LABEL}L:label"]="Create a label (\`L\`). Calling \`jump ${LABEL}L\` will execute code from the line at which \`L\` was defined."
	["${LABEL}label"]="All labels are prefixed by a \`$LABEL\`"
	["le [${VAR}]A:i [${VAR}]B:i"]='Checks if `A` is less than, or equal to, `B`. Returns a boolean. `A` or `B` can either be variables or single literals (no expressions)'
	["jump ${LABEL}L:label"]='Execute code starting from the line at which `L` was defined'
)
printf '# %s' "Syntax"
while read -r i
	do printf '\n## %s\n%s' "$i" "${syntax[$i]}"
done < <(printf '%s\n' "${!syntax[@]}" | sort)
