#!/usr/bin/env bash
set -uo pipefail
source .env
cat << EOF
What's a good way to implement a simple, line-based (Split lines on \`;\` before processing), language (let's call it \`${NAME^^}\` [file-types: \`$NAME\` / \`${NAME%86}\`]), in Rust, that compiles with \`nasm\` (don't just write it for me)?
# Example
\`\`\`$NAME
$(cat src/main.amc86)
\`\`\`
EOF
declare -A syntax=(
	["def TYPE ($VAR|$LABEL)VAR [EXPR...]"]="Declare a variable (\`VAR\`) and assign it to the value of \`EXPR\` (if \`TYPE\` is not \`label\`). Valid types include; $(
		printf '\n- %s' \
			'`int` (i64)' \
			'`str`' \
			'`bool` (identical to 1 or 0)' \
			'`label` (`EXPR` is omitted)' \
			| sort
	)"
	["print ${VAR}VAR:str"]="Write the value of \`VAR\` to standard output. \`VAR\` must be a defined variable"
	['println LIT:str(literal)']="First, assigns \`LIT\` to a variable (\`VAR\`). Next, writes the value of \`VAR\` to standard output"
	['incr $INT:int']="increase an integer variable (\`INT\`) by 1"
	["if [${VAR}]COND:bool EXPR..."]="Evaluates \`EXPR\` if \`COND\` is a true boolean"
	['exit [$]CODE:int']="Terminates the program with \`CODE\` as the exit code"
	["${VAR}variable"]="All variables are prefixed by a \`$VAR\`"
	["$COMMENT comment"]="A \`$COMMENT\` denotes the start of a comment. The rest of the line is not seen by the compiler"
	["${LABEL}label"]="All labels are prefixed by a \`$LABEL\`"
	["le [${VAR}]A:int [${VAR}]B:int"]="Checks if \`A\` is less than, or equal to, \`B\`. Returns a boolean. \`A\` or \`B\` can either be variables or single literals (no expressions)"
	["jump ${LABEL}LABEL:label"]="Execute code starting from the line at which \`LABEL\` was defined"
)
printf '# %s' "Syntax"
while read -r i
	do printf '\n## %s\n%s' "$i" "${syntax[$i]}"
done < <(printf '%s\n' "${!syntax[@]}" | sort)
