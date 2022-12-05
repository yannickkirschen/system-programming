; File: VARIABLS.ASM
;
; Demonstrates the usage of variables. Declares a variable, assigns a value and
; prints that value for inspection.

ORG  0x100
BITS 16

MOV BL, 'Y'
MOV BYTE[MY_VAR], BL    ; Copy value to variable

MOV DL, BL              ; Put content of variable into register for output
MOV AH, 2               ; Use function for output on screen
INT 21H                 ; Execute output

MOV AH, 0x4C            ; Use function for quitting the program
INT 0x21                ; Quit

MY_VAR DB 0             ; Declare 8-bit variable MY_VAR
