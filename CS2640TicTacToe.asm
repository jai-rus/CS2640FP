# Tic-Tac-Toe Game in MIPS Assembly
# Group 9: An Nguyen, Jairus Legion, Valeria Urzua, Viet Tran
# CS2640 Final Project
.include "CS2640FinalProjectGroup9Macros.asm"

# Board Size is 3x3
.eqv BOARD_SIZE 9

.data
# Game board (initialized to empty)
board: .space BOARD_SIZE

#Main Menu Messages
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

#Ingame Msgs
promptX:    .asciiz "\nPlayer X, enter index (0-8): "
promptO:    .asciiz "\nPlayer O, enter index (0-8): "
invalidStr: .asciiz "Invalid move - try again.\n"
xWinsStr:   .asciiz "\nPlayer X wins!\n"
oWinsStr:   .asciiz "\nPlayer O wins!\n"
drawStr:    .asciiz "\nIt's a draw!\n"
playAgainStr: .asciiz "\nReturning to main menu...\n"

#Current player
currentPlayer: .word 0

.text
.globl main

#Main prints welcome msg then jumps right into main
main:
    printString(welcomeMsg)
    j menu

#Main menu screen
menu:
    printString(mainMenu)
    # akes in input then echos back to user
    getInt()
    move $t0, $v0
    printString(echo)
    printInt($t0)
    
    #If input equals startGame
    li $t1, 1
    beq $t0, $t1, startGame
    
    #If input equals exit
    li $t1, 2
    beq $t0, $t1, exit
    
    #if invalid jump back to menu
    printString(invalidInput)
    j menu

startGame:
    printString(startMenu)
    #Reset current player to X (0)
    sw $zero, currentPlayer
    jal resetBoard
    jal playGameLoop
    j menu

#Gane Loop
#Main game loop that handles player turns
playGameLoop:
    #Save return address
    addi $sp, $sp, -4
    sw $ra, 0($sp)

playRound:
    #Print current board state
    jal printCurrentBoard

    #Determine which player's turn it is and prompt accordingly
    lw $t0, currentPlayer
    beqz $t0, promptXPlayer
    printString(promptO)   #Player O's turn
    j getPlayerMove

promptXPlayer:
    printString(promptX)   #Player X's turn

getPlayerMove:
    #Get player input
    getInt()
    move $t0, $v0  #Move user input to $t0
    
    #check if input is vlaid
    blt $t0, 0, badMove
    bgt $t0, 8, badMove
    
    #Check if position is already occupied
    la $t1, board
    add $t1, $t1, $t0      #Board address + index
    lb $t2, 0($t1)
    bnez $t2, badMove      #If not zero, position is occupied
    
    #Make the move
    lw $a2, currentPlayer  #Load current player (0=X, 1=O)
    la $a0, board          #Load board address
    move $a1, $t0          #Move index to $a1
    jal updateBoard
    
    #Check if game is over
    jal checkGameState     #Returns 0=continue, 1=X wins, 2=O wins, 3=draw
    beqz $v0, switchPlayer #If game not over, switch players
    j endGame              #Otherwise, game is over

badMove:
    printString(invalidStr)
    j playRound

switchPlayer:
    #Switch between players
    lw $t0, currentPlayer
    xori $t0, $t0, 1       #Toggle between 0/1
    sw $t0, currentPlayer  #Store updated player
    j playRound

endGame:
    li $t3, 1
    beq $v0, $t3, xWins
    li $t3, 2
    beq $v0, $t3, oWins
    j draw

xWins:
    printString(xWinsStr)
    j gameDone

oWins:
    printString(oWinsStr)
    j gameDone

draw:
    printString(drawStr)

gameDone:
    #Print final board state
    jal printCurrentBoard
    
    #Display return to menu message
    printString(playAgainStr)
    
    #Restore return address and return
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra

#Displays current board state
printCurrentBoard:
    addi $sp, $sp, -4    #Save $s0
    sw $s0, 0($sp)
    
    la $s0, board        
    li $t0, 0            #set the index to 0

printBoardLoop:
    add $t1, $s0, $t0    #board base + index
    lb $t2, 0($t1)       #load value at board[index]

    beqz $t2, printIndex #if value is 0, print the index number
    #else print letter
    li $v0, 11
    move $a0, $t2
    syscall
    j continuePrint

printIndex:
    move $a0, $t0
    li $v0, 1
    syscall

continuePrint:
    addi $t0, $t0, 1     #move to next index
    rem $t3, $t0, 3      #check if at end of row
    bnez $t3, printDivider

    #if at end of row (after 3 elements)
    li $v0, 4
    la $a0, newLine
    syscall

    #check if we are done (after 9 elements)
    li $t4, 9
    bge $t0, $t4, donePrint

    #print the horizontal line
    li $v0, 4
    la $a0, horizontalLine
    syscall
    li $v0, 4
    la $a0, newLine
    syscall

    j printBoardLoop

printDivider:
    li $v0, 4
    la $a0, verticalLine
    syscall
    j printBoardLoop

donePrint:
    lw $s0, 0($sp)      #Restore $s0
    addi $sp, $sp, 4
    jr $ra

#Upadte board with X or O at the index
updateBoard:
    #$a0 = board base
    #$a1 = index
    #$a2 = currentPlayer (0=X, 1=O)
    
    #Choose the character based on player
    beqz $a2, placeX
    li $t0, 'O'          #Player 1 uses 'O'
    j doPlacement
    
placeX:
    li $t0, 'X'          #Player 0 uses 'X'
    
doPlacement:
    add $t1, $a0, $a1    #Calculate position in board
    sb $t0, 0($t1)       #Store character at position
    jr $ra

#Check if a player won or drew
checkGameState:
    la $t0, board

#Check Rows
    li $t1, 0            #counter
row_loop:    
    lb $t2, 0($t0)       #load the first value in the board at index 0
    lb $t3, 1($t0)       #load the second value in the board at index 1 
    lb $t4, 2($t0)       #load the third value in the board at index 2
    beqz $t2, next_row   #if index 0 is empty go to next row
    bne  $t2, $t3, next_row #if index 0 and index 1 not equal (same O or same X)
    bne  $t2, $t4, next_row #if index 0 and index 3 not equal (Same O or same X)
    li $v0, 1            #X wins
    li $t5, 'O'          #set $t5 = O
    beq $t2, $t5, setOwin #if $t2 = O jump to setOwin
    jr  $ra            

next_row:
    addi $t0, $t0, 3     #move to next index 3,4,5 and 6,7,8
    addi $t1, $t1, 1     #increment 1 for counter
    blt  $t1, 3, row_loop #if $t1 < 3 jump back to row_loop

#Check Columns
    li $t1, 0            #load counter = 0 again
column_loop:
    la $t0, board
    add $t0, $t0, $t1
    lb $t2, 0($t0)       #now check column 0,3,6
    lb $t3, 3($t0)
    lb $t4, 6($t0)
    beqz $t2, next_column #if $t2 = 0 jump to next column
    bne  $t2, $t3, next_column #not same O or X in 0 and 3 index jump to next column
    bne  $t2, $t4, next_column #not same O or X in 0 and 3 index jump to next column
    li $v0, 1            #X wins
    li $t5, 'O'
    beq $t2, $t5, setOwin
    jr $ra

next_column:
    addi $t1, $t1, 1     #move to next column 1,4,7 then 2,5,8
    blt $t1, 3, column_loop #if $t1 < 3 jump back to column_loop

#Check diagonal
    la $t0, board        
    lb $t2, 0($t0)       #check diagonals 0,4,8
    lb $t3, 4($t0)
    lb $t4, 8($t0)
    beqz $t2, diag2      #if $t2 = 0 jump to diag2
    bne  $t2, $t3, diag2
    bne  $t2, $t4, diag2
    li $v0, 1            #X wins
    li $t5, 'O'
    beq $t2, $t5, setOwin
    jr $ra

diag2:
    la $t0, board
    lb $t2, 2($t0)       #check diagonals 2,4,6
    lb $t3, 4($t0)
    lb $t4, 6($t0)
    beqz $t2, check_draw  #if $t2 = 0 jump to check_draw
    bne  $t2, $t3, check_draw
    bne  $t2, $t4, check_draw
    li $v0, 1            #X wins
    li $t5, 'O'
    beq $t2, $t5, setOwin
    jr $ra

#Check if board is full (draw)
check_draw:
    la $t0, board
    li $t1, 0
draw_loop:
    lb $t2, 0($t0)       #$t2 = index 0 in board
    beqz $t2, keep_playing #if $t2 = 0 (empty) jump to keep playing
    addi $t0, $t0, 1     #increment index in board
    addi $t1, $t1, 1     #increment counter
    blt $t1, 9, draw_loop #if $t1 less than 9 jump back to draw_loop
    li $v0, 3            #Draw
    jr $ra

keep_playing:
    li $v0, 0            #Continue
    jr $ra

setOwin:
    li $v0, 2            #O wins
    jr $ra

#resets board for new game
resetBoard:
    la $t0, board        #load board
    li $t1, 0            #load 0 into $t1
    li $t2, 9            #total 9 places

clear_loop:
    sb $t1, 0($t0)       #store 0 into first index in the board
    addi $t2, $t2, -1    #remove 1 place
    addi $t0, $t0, 1     #move to next index
    bnez $t2, clear_loop #if places > 0 jump back to clear loop
    jr $ra

#Exit Program    
exit:
    printString(exitMsg)
    li $v0, 10
    syscall