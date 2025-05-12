## Tic-Tac-Toe in MIPS Assembly

**CS2640 Final Project – Group 9**  
**Contributors:** An Nguyen, Jairus Legion, Valeria Urzua, Viet Tran

## Project Overview
This project implements a simple, text-based Tic-Tac-Toe game written entirely in MIPS Assembly language as a final assignment for CS2640. The program allows two players to take turns entering moves on a 3x3 board, checks for win conditions, and provides a basic menu interface.

## Requirements
- MARS 4.5

## Files
- `CS2640FinalProjectGroup9.asm` – Main game logic  
- `CS2640FinalProjectGroup9Macros.asm` – Macro definitions

## How to Run
1. Open **MARS 4.5**.
2. Load both files:
   - `File > Open...` → Select `CS2640FinalProjectGroup9.asm`
   - Make sure `CS2640FinalProjectGroup9Macros.asm` is in the same directory.
3. Click **Assemble** (`F3`) and then **Run** (`F5`).

## Controls
- Main Menu:
  - `1` → Start game  
  - `2` → Exit  
- During the game:
  - Enter a number `0-8` to make a move
- At game end, press any key to return to the main menu

## Notes
- Board index layout:
  ```
   0 | 1 | 2
   -----------
   3 | 4 | 5
   -----------
   6 | 7 | 8
  ```
