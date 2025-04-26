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
#Print Welcome Message then jump to main menu
main:
	printString(welcomeMsg)
	j menu

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
	
# printIndexBoard
# prints the current board: numbers if empty, or X / O if occupied

printIndexBoard:
    la $s0, board        
    li $t0, 0            #set the index to 0

printBoardLoop:
    add $t1, $s0, $t0    #board base + index
    lb $t2, 0($t1)       #load value at board[index]

    beqz $t2, printIndex #if value is 0, print the index number
    # otherwise print the letter
    li $v0, 11
    move $a0, $t2
    syscall
    j continuePrint

printIndex:
    move $a0, $t0
    li $v0, 1
    syscall

continuePrint:
    addi $t0, $t0, 1     # move to next index
    rem $t3, $t0, 3      # check if at end of row
    bnez $t3, printDivider

    # if at end of row (after 3 elements)
    li $v0, 4
    la $a0, newLine
    syscall

    # check if we are done (after 9 elements)
    li $t4, 9
    bge $t0, $t4, donePrint

    # print the horizontal line
    li $v0, 4
    la $a0, horizontalLine
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

nextRow:
    j printBoardLoop

printDivider:
    li $v0, 4
    la $a0, verticalLine
    syscall
    j printBoardLoop

donePrint:
    jr $ra

    
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

#Exit Program	
exit:
	printString(exitMsg)
	li $v0, 10
	syscall
