# Example
```amc86
def i $i 0
label #start
	def s $str "Variable\n"; print $str // Identical
	print "Literal\n" // Identical (Alias)
	incr $i
	def b $loop le $i 10
	if $loop jump #start
exit 0
```
# Syntax
## $variable
All variables are prefixed by a `$`
## // comment
A `//` denotes the start of a comment. The rest of the line is not seen by the compiler
## def TYPE $V [EXPR...]
Declare a variable (`V`) and assign it to the value of `EXPR`. Valid types include; `b[ool]` (identical to 0 or 1), `i[nt]` (64-bit signed integer), `s[tr]`
## exit [$]C:i
Terminates the program with `C` as the exit code
## if [$]C:b E...
Evaluates `E` if `C` is a true boolean
## incr $I:i
increment `I` by 1
## jump #L:label
Execute code starting from the line at which `L` was defined
## #label
All labels are prefixed by a `#`
## label #L:label
Create a label (`L`). Calling `jump #L` will execute code from the line at which `L` was defined.
## le [$]A:i [$]B:i
Checks if `A` is less than, or equal to, `B`. Returns a boolean. `A` or `B` can either be variables or single literals (no expressions)
## print [$]V:s
Write the value of `V` to standard output. If `V` is not a defined variable, it will be defined first.