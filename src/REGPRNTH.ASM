; File: REGPRNTH.ASM
;
; Prints the content of the BL register as hex to the screen.

ORG  0x100
BITS 16

%macro PRINTSTRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

PRINTSTRING MESSAGE

MOV BL, 0x7E         ; Arbitrary content
PUSH BX              ; Push BX on the stack
MOV CX, 4            ; Number of bits to shift
SHR BL, CL           ; Shift 4 bits to the right
MOV DL, BL           ; Put content of BL into register for output
ADD DL, 0x30         ; Convert hex digit E to ASCII character E
CMP DL, 0x39         ; Check if DL is 0x39
JLE PRINT            ; If not bigger than 0x39 print normally
ADD DL, 7		     ; Otherwise add 7

PRINT:
    MOV AH, 2        ; Use function for output on screen
    INT 0x21         ; Execute output (character from DL)

    POP BX           ; Restore register from stack
    AND BL, 0x0F     ; Logic null left digit (alternative: 00001111B)
    MOV DL, BL       ; Put content of BL into register for output
    ADD DL, 0x30     ; Convert digit 7 to ASCII character 7

    JLE END          ; If not bigger than 0x39 print normally
    ADD DL, 7        ; Otherwise add 7

END:
    INT 21H	         ; Execute output

MOV AH, 0x4C     ; Use function for quiting the program
INT 0x21         ; Quit

MESSAGE DB "Output 8-Bit-Register (BL), Hex", 10, 13, "$"
