What's a good way to implement a simple, line-based, language
(Split lines on `;` before processing)
that compiles with `nasm`?
# AMC86
## Example
```amc86
let int $i 0
let label %start
	let str $i "Variable\n"; print $i # Identical
	print "Literal\n" # Identical
	incr $i
	let bool $loop le $i 10; if $loop jump %start
exit 0
```
## Syntax
### `comment`
A '#' denotes the start of a comment
The rest of the line is not seen by the compiler
### `exit CODE:int`
Terminates the program with CODE as the exit code
### `if COND:bool EXPR...`
Evaluates EXPR if COND is a true boolean
### `incr INT:int`
increase an integer variable (INT) by 1
### `label`
All labels are prefixed by a '%'
### `le A:T B:T`
Checks if A is less than, or equal to, B
Returns a boolean
A or B can either be a variable or a single literal
(no expressions)
### `let VAR EXPR...`
Declare a variable (VAR) and assign it to the value of EXPR.
Valid types include; 
- <bool (identical to int, but can only be 1 or 0)>
- <int (i64)>
- <label>
- <str>
### `print "LIT"`
First, assigns LIT to a variable (VAR)
Next, writes the value of VAR to standard output
### `print VAR:str`
Write the value of VAR to standard output
VAR must be a defined variable
### `variable`
All variables are prefixed by a '$'
