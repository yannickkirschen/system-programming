; File: STRNGCPY.ASM
;
; Copies a predefined string to another variable.

ORG  0x100
BITS 16

%macro PRINT_STRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

PRINT_STRING LINE_FEED
PRINT_STRING MESSAGE_1
PRINT_STRING SOURCE
PRINT_STRING LINE_FEED

MOV SI, SOURCE              ; Reference of source string (first element)
MOV DI, TARGET              ; Reference of target string (first element)

COPY:
    CMP BYTE[SI], "$"       ; Is the current character the string end character?
    JZ END                  ; Jump to end if we reached end of string

    MOV DL, BYTE[SI]        ; Copy current character to DL
    MOV BYTE[DI], DL        ; Copy current character from DL to target string

    INC SI                  ; Increase source index (will be the character in next loop)
    INC DI                  ; Increase target index (will be the character in next loop)

    JMP COPY                ; Loop until end of string is reached

END:
    MOV BYTE[DI], "$"       ; Add end of string character to target

    PRINT_STRING LINE_FEED
    PRINT_STRING MESSAGE_2
    PRINT_STRING TARGET

MOV AH, 0x4C                ; Use function for quitting the program
INT 0x21                    ; Quit

MESSAGE_1 DB "Source:", "$"
MESSAGE_2 DB "Target:", "$"
LINE_FEED DB 10, 13, "$"
SOURCE    DB "This is a predefined string$"
TARGET    DB "**********************************************************************$"
