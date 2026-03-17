#!/usr/bin/env bash
set -uo pipefail
name=amc86
exec > README.md
(
	label() {
		printf '#%s' "$1"
	}
	var() {
		printf '$%s' "$1"
	}
	comment() {
		printf '%s' --
		printf ' %s' "$@"
	}
	str() {
		printf '"%s\\n"' "$1"
	}
	def() {
		type=$1
		id=$2
		shift 2
		if [[ $type == label ]]; then
			id=$(label "$id")
		else
			id=$(var "$id")
		fi
		if [[ $type == str ]]; then
			value=$(str "$@")
		fi
		if [[ $type != label ]]; then
			value="$id ${value:-$@}"
		else
			value=$id
		fi
		printf 'def %s %s' "$type" "$value"
	}
	print() {
		if [[ $1 == var ]]; then
			kind=v
			shift
		else
			kind=l
		fi
		case "$kind" in
			v) value=$(var "$1");;
			l) value=$(str "$1");;
		esac
		printf 'print %s' "$value"
	}
	incr() {
		printf 'incr %s' "$(var "$1")"
	}
	le() {
		args=()
		for i in {1..2}; do
			if [[ $1 == var ]]; then
				shift
				args+=("$(var "$1")")
			else
				args+=("$1")
			fi
			shift
		done
		printf 'le %s %s' "${args[@]}"
	}
	if_else() {
		cond=$1
		shift
		action=$*
		printf 'if %s %s' "$cond" "$action"
	}
	e() {
		if [[ $1 == var ]]; then
			code=$(var "$1")
			shift
		else
			code=$1
		fi
		shift
		printf 'exit %s' "$code"
	}
	cat << EOF
$(def int i 0)
$(def label start)
	$(def str str Variable); $(print var str) $(comment Identical)
	$(print Literal) $(comment Identical '(Alias)')
	$(incr i)
	$(def bool loop "$(le var i 10)"); $(if_else "$(var loop)" jump "$(label start)")
$(e 0)
EOF
) > src/main.amc86
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
	['def VAR EXPR...']="$(
		printf '%s\n' \
			'Declare a variable (VAR) and assign it to the value of EXPR.' \
			'Valid types include; '"$(
				printf '\n- `%s`' "${types[@]}" | sort
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
	['le A:int B:int']="$(
		printf '%s\n' \
			'Checks if A is less than, or equal to, B' \
			'Returns a boolean' \
			'A or B can either be variables or single literals' \
			'(no expressions)'
	)"
)
printf '## %s\n' "Syntax"
while read -r i
	do printf '### `%s`\n%s\n' "$i" "${syntax[$i]}"
done < <(printf '%s\n' "${!syntax[@]}" | sort)
