#!/usr/bin/env bash
set -uo pipefail
line() {
	for _ in {1..50}
		do printf '='
	done
	printf '\n'
}
label() {
	printf '%%%s' "$1"
}
var() {
	printf '$%s' "$1"
}
com() {
	printf '# %s' "$1"
}
str() {
	printf '"%s\\n"' "$1"
}
name=amc86
exec > index.md
cat << EOF > src/main.amc86
let int $(var i) 0
let label $(label start)
	let str $(var i) $(str Variable); print $(var i) $(com Identical)
	print $(str Literal) $(com Identical)
	incr $(var i)
	let bool $(var loop) le $(var i) 10; if $(var loop) jump $(label start)
exit 0
EOF
cat << EOF
What's a good way to implement a simple, line-based, language
(Split lines on \`;\` before processing)
that compiles with \`nasm\`?
# ${name^^}
## Example
\`\`\`$name
$(cat src/main.amc86)
\`\`\`
EOF
types=(
	'int (i64)'
	str
	'bool (identical to int, but can only be 1 or 0)'
	label
)
declare -A syntax=(
	['let VAR EXPR...']="$(
		printf '%s\n' \
			'Declare a variable (VAR) and assign it to the value of EXPR.' \
			'Valid types include; '"$(
				printf '\n- <%s>' "${types[@]}" | sort
			)"
	)"
	['print VAR:str']="$(printf '%s\n' \
		'Write the value of VAR to standard output' \
		'VAR must be a defined variable'
	)"
	['print "LIT"']="$(
		printf '%s\n' \
			"First, assigns LIT to a variable (VAR)" \
			'Next, writes the value of VAR to standard output'
	)"
	['incr INT:int']='increase an integer variable (INT) by 1'
	['if COND:bool EXPR...']='Evaluates EXPR if COND is a true boolean'
	['exit CODE:int']='Terminates the program with CODE as the exit code'
	['variable']='All variables are prefixed by a '"'$'"
	['comment']="$(printf '%s\n' \
		'A '"'#'"' denotes the start of a comment' \
		'The rest of the line is not seen by the compiler'
	)"
	['label']='All labels are prefixed by a '"'%'"
	['le A:T B:T']="$(
		printf '%s\n' \
			'Checks if A is less than, or equal to, B' \
			'Returns a boolean' \
			'A or B can either be a variable or a single literal' \
			'(no expressions)'
	)"
)
printf '## %s\n' "Syntax"
while read -r i
	do printf '### `%s`\n%s\n' "$i" "${syntax[$i]}"
done < <(printf '%s\n' "${!syntax[@]}" | sort)
