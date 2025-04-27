# game_loop.asm
# Module: Game loop & player-turn control
# (macros already brought in by main)

.include "CS2640FinalProjectCheckGameState.asm"

.data
promptX:    .asciiz "\nPlayer X, enter index (0-8): "
promptO:    .asciiz "\nPlayer O, enter index (0-8): "
invalidStr: .asciiz "Invalid move - try again.\n"
xWinsStr:   .asciiz "\nPlayer X wins!\n"
oWinsStr:   .asciiz "\nPlayer O wins!\n"
drawStr:    .asciiz "\nIt’s a draw!\n"

.text
.globl playGameLoop
playGameLoop:
    # Initialize
    la   $s1, board        # board[] base (from main .data)
    li   $s0, 0            # currentPlayer: 0 = X, 1 = O

playRound:
    # — prompt current player —
    beq  $s0, 0, L_px
    printString(promptO)
    j    L_afterPrompt
L_px:
    printString(promptX)
L_afterPrompt:

    # — get & validate input —
    getInt                 # user input → $t0
    blt  $t0, 0, L_bad
    bgt  $t0, 8, L_bad
    add  $t1, $s1, $t0     # addr = board + index
    lb   $t2, 0($t1)
    bnez $t2, L_bad        # occupied?

    # — commit move & check state —
    move $a0, $s1          # board ptr
    move $a1, $t0          # index
    move $a2, $s0          # player
    jal  updateBoard

    move $a0, $s1
    jal  checkGameState    # returns 0=cont,1=X,2=O,3=draw
    beq  $v0, $zero, L_next
    j    L_endGame

L_bad:
    printString(invalidStr)
    j    playRound

L_next:
    xori $s0, $s0, 1       # toggle player
    j    playRound

L_endGame:
    li   $t3, 1
    beq  $v0, $t3, L_xwin
    li   $t3, 2
    beq  $v0, $t3, L_owin
    j    L_draw

L_xwin:
    printString(xWinsStr)
    j    L_done

L_owin:
    printString(oWinsStr)
    j    L_done

L_draw:
    printString(drawStr)

L_done:
    jal resetBoard
    j 	menu

# — real updateBoard: write 'X' or 'O' into board[index] —
.globl updateBoard
updateBoard:
    # $a0 = board base
    # $a1 = index
    # $a2 = currentPlayer (0=X,1=O)
    li   $t3, 'X'
    bne  $a2, $zero, storeO
    j    doStore

storeO:
    li   $t3, 'O'

doStore:
    add  $t4, $a0, $a1
    sb   $t3, 0($t4)
    jr   $ra
