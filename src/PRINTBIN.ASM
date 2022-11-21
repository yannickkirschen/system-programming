; File: PRINTBIN.ASM
;
; Prints all dual digits of a hexadecimal number by using JC, PUSHF, POPF, CALL
; and RET.

ORG  0x100
BITS 16

%macro PUSHALL 0
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
%endmacro

%macro PRINTSTRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

M1:
    MOV AX, 0x0AB3F          ; Number we want to display in Hex
    MOV CX, 16               ; 8 Bit should get displayed

MAIN_LOOP:
    RCL AX, 1                ; Rotate AX by 1 -> if rotated bit is 1: set carry flag
    CALL PRINT_DUAL_DIGIT    ; Call subroutine to print dual digit
    LOOP MAIN_LOOP           ; Loop until CX = 0

ENDE:
    MOV AH, 0x4C             ; Use function for quiting the program
    INT 0x21                 ; Quit

; ---------- PRINT DUAL DIGIT ----------
PRINT_DUAL_DIGIT:
    PUSHALL                  ; Push all registers onto the stack
    PUSHF                    ; Push all flags onto the stack

    DEC CL                   ; Reduce CX by one, as we begin with the 0-th bit
    MOV DL, CL               ; Move index to DL for it to display

    ADD DL, 0x30             ; Mask index for ASCII output
    CMP DL, 0x39             ; Compare to '9'

    JLE OUTPUT               ; Print index directly (0-9 indices)
    ADD DL, 7                ; Add '7' to index for A-F indices

OUTPUT:
    MOV AH, 2                ; Use function for output on screen
    INT 0x21                 ; Execute output

    POPF                     ; Load flags from stack
    JC PRINT_MESSAGE_SET     ; Print that the bit is set, if carry flag is set

    PRINTSTRING MESSAGE_NOT_SET
    JMP PRINT_DUAL_DIGIT_END ; Goto end of routine if carry flag is not set

PRINT_MESSAGE_SET:
    PRINTSTRING MESSAGE_SET

PRINT_DUAL_DIGIT_END:
    POPALL
    RET
; ---------- PRINT DUAL DIGIT ----------

MOV AH, 0X4C       ; USE FUNCTION FOR QUITING THE PROGRAM
INT 0X21           ; QUIT

MESSAGE_SET DB ". BIT IS 1", 10, 13, "$"
MESSAGE_NOT_SET  DB ". BIT IS 0", 10, 13, "$"
