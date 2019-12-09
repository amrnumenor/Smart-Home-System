# Macro program to ease syscall coding
# The macros name is self-explanatory

.macro print_int(%x)
li $v0, 1
add $a0, %x
syscall
.end_macro

.macro print_str(%str)
li $v0, 4
la $a0, %str
syscall
.end_macro

.macro read_int
li $v0, 5
syscall
.end_macro

.macro read_str(%adr, %buf)
li $v0, 8
move $a0, %adr
li $a1, %buf
.end_macro 

.macro exit_
li $v0, 10
syscall
.end_macro
