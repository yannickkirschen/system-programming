; File: FLAGS.ASM
;
; Demonstrates how flags work. Executes a subtraction and prints all registers.

ORG  0x100
BITS 16

%macro PUSH_ALL 0
    PUSHF

    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
%endmacro

%macro POP_ALL 0
    POP DX
    POP CX
    POP BX
    POP AX

    POPF
%endmacro

%macro PRINT_STRING 1
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
    PUSH_ALL                            ; Save all registers, including flags
    JC CARRY_SET                        ; Jump if carry is set

    PRINT_STRING CARRY_NO_STRING
    PRINT_STRING LINE_FEED_STRING

    JMP PARITY_CHECK

CARRY_SET:
    PRINT_STRING CARRY_YES_STRING
    PRINT_STRING LINE_FEED_STRING

PARITY_CHECK:
    POP_ALL                             ; Restore all registers including flags
    PUSH_ALL                            ; Save all registers, including flags

    JPE PARITY_EQUAL                    ; Jump if parity is even
    PRINT_STRING PARITY_ODD_STRING
    PRINT_STRING LINE_FEED_STRING

    JMP ZERO_CHECK

PARITY_EQUAL:
    PRINT_STRING PARITY_EQUAL_STRING
    PRINT_STRING LINE_FEED_STRING

ZERO_CHECK:
    POP_ALL                             ; Restore all registers including flags
    PUSH_ALL                            ; Save all registers, including flags

    JZ ZERO_NULL                        ; Jump if zero is set
    PRINT_STRING ZERO_NO_STRING
    PRINT_STRING LINE_FEED_STRING

    JMP SIGN_CHECK

ZERO_NULL:
    PRINT_STRING ZERO_YES_STRING
    PRINT_STRING LINE_FEED_STRING

SIGN_CHECK:
    POP_ALL                             ; Restore all registers including flags

    JS SIGN_NEGATIVE                    ; Jump if sign is set (result is negative)
    PRINT_STRING SIGN_POS_STRING
    PRINT_STRING LINE_FEED_STRING

    JMP END

SIGN_NEGATIVE:
    PRINT_STRING SIGN_NEG_STRING
    PRINT_STRING LINE_FEED_STRING

END:
    MOV AH, 0X4C                        ; Use function for quitting the program
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
