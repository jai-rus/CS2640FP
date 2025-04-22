#Prints out a string
.macro printString(%msg)
	li $v0, 4
	la $a0, %msg
	syscall
.end_macro

#Takes in an integer input and save its in $t0
.macro getInt()
	li $v0, 5
	syscall
	move $t0, $v0
.end_macro

#Prints out an integer
.macro printInt(%address)
	li $v0, 1
	move $a0, %address
	syscall
.end_macro
