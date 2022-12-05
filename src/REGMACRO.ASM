; File: REGMACRO.ASM
;
; Provides a macro that prints the content of a 16-bit register to the screen.

ORG  0x100
BITS 16

%macro PRINT_STRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

%macro REGISTER_PRINT 1
    PUSH %1              ; Push register on the stack
    MOV CX, 4            ; Number of bits to shift
    SHR BL, CL           ; Shift 4 bits to the right
    MOV DL, BL           ; Put content of BL into register for output
    ADD DL, 0x30         ; Convert hex digit E to ASCII character E
    CMP DL, 0x39         ; Check if DL is 0x39
    JLE %%PRINT          ; If not bigger than 0x39 print normally
    ADD DL, 7		     ; Otherwise add 7

    %%PRINT:
        MOV AH, 2        ; Use function for output on screen
        INT 21H          ; Execute output (character from DL)

        POP %1           ; Restore register from stack
        AND BL, 0x0F     ; Logic null left digit (alternative: 00001111B)
        MOV DL, BL       ; Put content of BL into register for output
        ADD DL, 0x30     ; Convert digit 7 to ASCII character 7

        JLE %%END        ; If not bigger than 0x39 print normally
        ADD DL, 7        ; Otherwise add 7

    %%END:
        INT 0x21         ; Execute output
%endmacro

PRINT_STRING MESSAGE

MOV BX, 0x7E3A           ; Arbitrary content
XCHG BL, BH              ; Swap BL and BH cause high should be printed first
REGISTER_PRINT BX        ; Print BX (high)
XCHG BL, BH              ; Swap again
REGISTER_PRINT BX        ; Print BX (low)

MOV AH, 0x4C             ; Use function for quitting the program
INT 0x21                 ; Quit

MESSAGE DB "Output 16-Bit-Register (BX), Hex", 10, 13, "$"
