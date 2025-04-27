#CheckGameState.asm
#Function: determine if a player draw or win in vertically, horizontally or diagonally

.globl checkGameState
checkGameState:
    	la $t0, board

#Check Rows
    	li $t1, 0			#counter
row_loop:	
    	lb $t2, 0($t0)			#load the first value in the board at index 0
    	lb $t3, 1($t0)			#load the second value in the board at index 1 
    	lb $t4, 2($t0)			#load the third value in the board at index 2
    	beqz $t2, next_row		#if index 0 is empty go to next row
    	bne  $t2, $t3, next_row		#if index 0 and index 1 not equal (same O or same X)
    	bne  $t2, $t4, next_row		#if index 0 and index 3 not equal (Same O or same X)
    	li $v0, 1			#X wins
    	li $t5, 'O'			#set $t5 = O
    	beq $t2, $t5, setOwin		#if $t2 = O jump to setOwin
    	jr  $ra			

next_row:
    	addi $t0, $t0, 3		#move to next index 3,4,5 and 6,7,8
    	addi $t1, $t1, 1		#increment 1 for counter
    	blt  $t1, 3, row_loop		#if $t1 < 3 jump back to row_loop

#Check Columns
    	li $t1, 0			#load counter = 0 again
column_loop:
    	la $t0, board
    	add $t0, $t0, $t1
    	lb $t2, 0($t0)			#now check column 0,3,6
    	lb $t3, 3($t0)
    	lb $t4, 6($t0)
    	beqz $t2, next_column		#if $t2 = 0 jump to next column
    	bne  $t2, $t3, next_column	#not same O or X in 0 and 3 index jump to next column
    	bne  $t2, $t4, next_column	#not same O or X in 0 and 3 index jump to next column
    	li $v0, 1			#X wins
    	li $t5, 'O'
    	beq $t2, $t5, setOwin
    	jr $ra

next_column:
    	addi $t1, $t1, 1		#move to next column 1,4,7 then 2,5,8
    	blt $t1, 3, column_loop		#if $t1 < 3 jump back to column_loop

#Check Diagonals
    	la $t0, board		
    	lb $t2, 0($t0)			#check diagonals 0,4,8
    	lb $t3, 4($t0)
    	lb $t4, 8($t0)
    	beqz $t2, diag2			#if $t2 = 0 jump to diag2
    	bne  $t2, $t3, diag2
    	bne  $t2, $t4, diag2
    	li $v0, 1			#X wins
    	li $t5, 'O'
    	beq $t2, $t5, setOwin
    	jr $ra

diag2:
    	la $t0, board
    	lb $t2, 2($t0)			#check diagonals 2,4,6
    	lb $t3, 4($t0)
    	lb $t4, 6($t0)
    	beqz $t2, check_draw		#if $t2 = 0 jump to check_draw
    	bne  $t2, $t3, check_draw
    	bne  $t2, $t4, check_draw
    	li $v0, 1			#X wins
    	li $t5, 'O'
    	beq $t2, $t5, setOwin
    	jr $ra

#Check if board is full (draw)
check_draw:
    	la $t0, board
    	li $t1, 0
draw_loop:
    	lb $t2, 0($t0)			#$t2 = index 0 in board
    	beqz $t2, keep_playing		#if $t2 = 0 (empty) jump to keep playing
    	addi $t0, $t0, 1		#increment index in board
    	addi $t1, $t1, 1		#increment counter
    	blt $t1, 9, draw_loop		#if $t1 less than 9 jump back to draw_loop
    	li $v0, 3			#Draw
    	jr $ra

keep_playing:
    	li $v0, 0			#Continue
    	jr $ra

setOwin:
    	li $v0, 2			#O wins
    	jr $ra

.globl resetBoard
resetBoard:
	la $t0, board			#load board
	li $t1, 0			#load 0 into $t1
	li $t2, 9			#total 9 places

clear_loop:
	sb $t1, 0($t0)			#store 0 into first index in the board
	addi $t2, $t2, -1		#remove 1 place
	addi $t0, $t0, 1		#move to next index
	bnez $t2, clear_loop		#if places > 0 jump back to clear loop
	jr $ra
