; File: ARRYDEMO.ASM
;
; Writes the characters from A to B into an array and prints them afterwards.

ORG  0x100
BITS 16

MOV BL, 'A'          ; Start with an A

; Initialize array
MOV [ARR], BL        ; Copy value of BL to first position of array
INC BL               ; Increment BL counter
MOV [ARR + 1], BL    ; Copy value of BL to second position of array
INC BL
MOV [ARR + 2], BL
INC BL
MOV [ARR + 3], BL

; Print array
MOV AH, 2            ; Use function for output on screen
MOV DL, [ARR]        ; Copy value of first element of array into DL
INT 0x21             ; Execute output
MOV DL, [ARR + 1]    ; Copy value of second element of array into DL
INT 0x21             ; Execute output
MOV DL, [ARR + 2]
INT 0x21
MOV DL, [ARR + 3]
INT 0x21

MOV AH, 0x4C         ; Use function for quitting the program
INT 0x21             ; Quit

ARR: TIMES 5 DB 0    ; Declare Array with length of 5
