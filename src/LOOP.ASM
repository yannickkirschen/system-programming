; File: LOOP.ASM
;
; Demonstrates the use of a loop by printing the characters from A to Z.

ORG  0x100
BITS 16

MOV CX, 26         ; Number of loops (in this case: number of characters in the alphabet)
MOV DL, 'A'        ; Start with letter 'A'
MOV AH, 2          ; Use function for output on screen

MARKER:
    INT 0x21       ; Execute output
    INC DL         ; Next character
    LOOP MARKER    ; Loop until CX = 0

MOV AH, 0x4C       ; Use function for quitting the program
INT 0x21           ; Quit
