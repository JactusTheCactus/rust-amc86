What's a good way to implement a simple, line-based (Split lines on `;` before processing), language (let's call it `AMC86` [file-types: `amc86` / `amc`]), in Rust, that compiles with `nasm` (don't just write it for me)?
# Example
```amc86
def int $i 0
def label #start
	def str $str "Variable\n"; print $str // Identical
	print "Literal\n" // Identical (Alias)
	incr $i
	def bool $loop le $i 10; if $loop jump #start
exit 0
```
# Syntax
## $variable
All variables are prefixed by a `$`
## // comment
A `//` denotes the start of a comment. The rest of the line is not seen by the compiler
## def TYPE ($|#)VAR [EXPR...]
Declare a variable (`VAR`) and assign it to the value of `EXPR` (if `TYPE` is not `label`). Valid types include; 
- `bool` (identical to 1 or 0)
- `int` (i64)
- `label` (`EXPR` is omitted)
- `str`
## exit [$]CODE:int
Terminates the program with `CODE` as the exit code
## if [$]COND:bool EXPR...
Evaluates `EXPR` if `COND` is a true boolean
## incr $INT:int
increase an integer variable (`INT`) by 1
## jump #LABEL:label
Execute code starting from the line at which `LABEL` was defined
## #label
All labels are prefixed by a `#`
## le [$]A:int [$]B:int
Checks if `A` is less than, or equal to, `B`. Returns a boolean. `A` or `B` can either be variables or single literals (no expressions)
## print $VAR:str
Write the value of `VAR` to standard output. `VAR` must be a defined variable
## println LIT:str(literal)
First, assigns `LIT` to a variable (`VAR`). Next, writes the value of `VAR` to standard output