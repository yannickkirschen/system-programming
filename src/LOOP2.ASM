; File: LOOP2.ASM
;
; Demonstrates the use of a loop by printing the characters from Z to V.

ORG  0x100
BITS 16

MOV CX, 5         ; Number of loops
MOV DL, 'Z'       ; Start with letter 'Z'
MOV AH, 2         ; Use function for output on screen

MARKER:
    INT 0x21      ; Execute output
    DEC DL        ; Next character
    LOOP MARKER   ; Loop until CX = 0

MOV AH, 0x4C      ; Use function for quitting the program
INT 0x21          ; Quit
