; File: FLAGS.ASM
;
; Demonstrates how flags work. Executes a subtraction and prints all registers.

ORG  0X100
BITS 16

%macro PUSHALL 0
    PUSHF

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
%endmacro

%macro POPALL 0
    POP DX
    POP CX
    POP BX
    POP AX

    POPF
%endmacro

%macro PRINTSTRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

; Operation to demonstrate the flags
; Result is -2
; This means: carry, odd 1s, no zero, negative
MOV AX, 7
MOV BX, 9
SUB AX, BX

CARRY_CHECK:
    PUSHALL                             ; Save all registers, including flags
    JC CARRY_SET                        ; Jump if carry is set

    PRINTSTRING CARRY_NO_STRING
    PRINTSTRING LINE_FEED_STRING

    JMP PARITY_CHECK

CARRY_SET:
    PRINTSTRING CARRY_YES_STRING
    PRINTSTRING LINE_FEED_STRING

PARITY_CHECK:
    POPALL                              ; Restore all registers including flags
    PUSHALL                             ; Save all registers, including flags

    JPE PARITY_EQUAL                    ; Jump if parity is even
    PRINTSTRING PARITY_ODD_STRING
    PRINTSTRING LINE_FEED_STRING

    JMP ZERO_CHECK

PARITY_EQUAL:
    PRINTSTRING PARITY_EQUAL_STRING
    PRINTSTRING LINE_FEED_STRING

ZERO_CHECK:
    POPALL                              ; Restore all registers including flags
    PUSHALL                             ; Save all registers, including flags

    JZ ZERO_NULL                        ; Jump if zero is set
    PRINTSTRING ZERO_NO_STRING
    PRINTSTRING LINE_FEED_STRING

    JMP SIGN_CHECK

ZERO_NULL:
    PRINTSTRING ZERO_YES_STRING
    PRINTSTRING LINE_FEED_STRING

SIGN_CHECK:
    POPALL                              ; Restore all registers including flags

    JS SIGN_NEGATIVE                    ; Jump if sign is set (result is negative)
    PRINTSTRING SIGN_POS_STRING
    PRINTSTRING LINE_FEED_STRING

    JMP END

SIGN_NEGATIVE:
    PRINTSTRING SIGN_NEG_STRING
    PRINTSTRING LINE_FEED_STRING

END:
    MOV AH, 0X4C                        ; Use function for quiting the program
    INT 0X21                            ; Quit

CARRY_YES_STRING    DB "Carry is set$"
CARRY_NO_STRING     DB "Carry is not set$"

PARITY_EQUAL_STRING DB "Number of 1s is equal$"
PARITY_ODD_STRING   DB "Number of 1s is odd$"

ZERO_YES_STRING     DB "Zero is set$"
ZERO_NO_STRING      DB "Zero is not set$"

SIGN_POS_STRING     DB "Result is positive$"
SIGN_NEG_STRING     DB "Result is negative$"

LINE_FEED_STRING    DB 13, 10, "$"
