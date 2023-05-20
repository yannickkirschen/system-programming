; File: HEXINP.ASM
;
; Waits for the input of two hex digits and stores them in BL.

ORG  0X100
BITS 16

FIRST:
    MOV AH, 0x1  ; Function for keyboard input (with output of character)
    INT 0x21     ; Trigger first input; character is in AL
    CMP AL, 0x39 ; Check if AL is >= 9 (decimal)
    JLE SECOND   ; AL is < 9, so we have read a decimal number
    SUB AL, 7    ; AL is >= 9, so we have read a non-decimal number, so we make it one

SECOND:
    SUB AL, 0x30 ; To get the decimal number
    MOV BL, AL   ; Save first number in BL
    SHL BL, 4    ; Shift first number to the left -> second number will be in the right

    INT 0x21     ; Trigger second input
    CMP AL, 0x39
    JLE END
    SUB AL, 7

END:
    SUB AL, 0x30
    ADD BL, AL   ; As we shifted the first number to the left, the lower 4 bits contain AL now

MOV AH, 0x4C     ; Function for quitting the program
INT 0x21         ; Quit
