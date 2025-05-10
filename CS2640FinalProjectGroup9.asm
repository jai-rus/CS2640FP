#An Nguyen, Jairus Legion, Valeria Urzua, Viet Tran
#CS2640
#Final Project Group 9
.include "CS2640FinalProjectGroup9Macros.asm"


#Board Size is 3x3
.eqv BOARD_SIZE 9

.data
board: .space BOARD_SIZE
welcomeMsg: .asciiz "Welcome to our Tic-Tac-Toe game! To get started, please see the options below!"
mainMenu: .asciiz "\n---------\nTo play a game please enter (1)\nTo exit please enter (2)\n---------\n"
echo: .asciiz "You chose: "
invalidInput: .asciiz "Invalid choice. Please try again\n"
startMenu: .asciiz "\nNow starting a game.\n"
exitMsg: .asciiz "\nThanks for playing! Goodbye!"
newLine: .asciiz "\n"
verticalLine: .asciiz " | "
horizontalLine: .asciiz "-----------"
promptIndex: .asciiz "If you would like to see the index please input (3)"

#Maybe save $t0 as the main input variable

.text
.globl main

#Print Welcome Message then jump to main menu
main:
	printString(welcomeMsg)
	j menu

# include CS2640FinalProjectGameLoop .asm file
.include "CS2640FinalProjectGameLoop.asm"

#Prints menu then waits for input	
menu:
	printString(mainMenu)
	#Takes in input then echos back to user
	getInt()
	printString(echo)
	printInt($t0)
	
	#If input equals startGame
	li $t1, 1
	beq $t0, $t1, startGame
	
	#If input equals exit
	li $t1, 2
	beq $t0, $t1, exit
	
	#Invalid Input
	printString(invalidInput)
	j menu
	
startGame:
	printString(startMenu)
	#Index of the position on the board
	li $t1, 0
	j printIndexBoard


	
printIndexBoard:
	#Print current number
	printInt($t1)
	
	#Determine if we're at the end of a row (2, 5, 8)
	add $t1, $t1, 1
	rem $t2, $t1, 3
	bnez $t2, printDivide #if not 0, print " | "
	
	#Print newline and horizontal after each row
	printString(newLine)
	
	#Check if index is 9, if it is return to menu
	li $t3, 9
	bge $t1, $t3, PI_startGame
	
	printString(horizontalLine)
	
	printString(newLine)
	
	j printIndexBoard

#Print horizontal separator
printHorizontal:
	printString(newLine)
	printString(horizontalLine)

#Print divisor between numbers
printDivide:
	li $v0, 4
	la $a0, verticalLine
	syscall
	j printIndexBoard

PI_startGame:
    jal  playGameLoop
    j    menu


#Exit Program	
exit:
	printString(exitMsg)
	li $v0, 10
	syscall
	
