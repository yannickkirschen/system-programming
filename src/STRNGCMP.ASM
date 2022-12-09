; File: STRNGCMP.ASM
;
; Compares two predefined strings.

ORG  0x100
BITS 16

%macro PRINT_STRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

%macro STRING_LENGTH 2
    MOV SI, %1                         ; Reference of string to check (first element)
    MOV BX, SI                         ; Load address of first character to BX

    %%LENGTH_LOOP:
        CMP BYTE[SI], '$'              ; Is the current character the string end character?
        JE %%CALCULATE                 ; Calculate length of string if end of string is reached

        INC SI                         ; Increase string index (will be the character in next loop)
        JMP %%LENGTH_LOOP              ; Loop until end of string is reached

    %%CALCULATE:
        MOV AX, SI                     ; Load index of last character to AX
        SUB AX, BX                     ; Subtract index of first character (this will result in the length)
        MOV BYTE[%2], AL               ; Write length to variable
%endmacro

STRING_LENGTH SOURCE, SOURCE_LENGTH    ; Calculate length of source string

MOV SI, SOURCE                         ; Reference of source string (first element)
MOV DI, TARGET                         ; Reference of target string (first element)

MOV CL, [SOURCE_LENGTH]                ; Load length of source string into CL (will be the number of loops)
MOV CH, 0                              ; Just to be sure we have an 8 bit variable in CX

; Alternative:
; MOV AL, 0
XOR AL, AL                             ; Erase potential data in AL

MAIN_LOOP:
    MOV AL, BYTE[SI]                   ; Load source character
    MOV BL, BYTE[DI]                   ; Load target character

    CMP AL, BL                         ; Compares both characters
    JNE PRINT_DIFFERENT                ; The characters are not equal

    INC SI                             ; Increase source index (will be the character in next loop)
    INC DI                             ; Increase target index (will be the character in next loop)
    LOOP MAIN_LOOP                     ; Loop unless characters are not equal

    JMP PRINT_IDENTICAL                ; All characters are identical

PRINT_DIFFERENT:
    PRINT_STRING MESSAGE_DIFFERENT
    JMP END

PRINT_IDENTICAL:
    PRINT_STRING MESSAGE_IDENTICAL
    JMP END

END:
    MOV AH, 0x4C                       ; Use function for quitting the program
    INT 0x21                           ; Quit

MESSAGE_IDENTICAL DB "Both strings are identical.", "$"
MESSAGE_DIFFERENT DB "Both strings are different.", "$"

LINE_FEED         DB 10, 13, "$"

SOURCE            DB "A predefined string$"
TARGET            DB "A predefined string$"

SOURCE_LENGTH     DB 0                 ; Length of source string
