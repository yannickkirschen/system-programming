; File: REGPRNT.ASM
;
; Prints the content of the BL register to the screen.

ORG  0x100
BITS 16

%macro PRINTSTRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

PRINTSTRING MESSAGE

MOV BL, 0x75     ; Arbitrary content in BL
PUSH BX          ; Push BX on the stack
MOV CX, 4        ; Number of bits to shift
SHR BL, CL       ; Shift 4 bits to the right
MOV DL, BL       ; Put content of BL into register for output
ADD DL, 0x30     ; Convert digit 7 to ASCII character 7

MOV AH, 2        ; Use function for output on screen
INT 0x21         ; Execute output (this will print the '7' on the screen)

POP BX           ; Restore register from stack
AND BL, 0x0F     ; Logic null left digit (alternative: 00001111B)
MOV DL, BL       ; Put content of BL into register for output
ADD DL, 0x30     ; Convert digit 5 to ASCII character 5
INT 0x21         ; Execute output (this will print the '5' on the screen, function 2 still in AH)

MOV AH, 0x4C     ; Use function for quiting the program
INT 0x21         ; Quit

MESSAGE DB "Output 8-Bit-Register (BL), Digits 0 to 9", 10, 13, "$"
