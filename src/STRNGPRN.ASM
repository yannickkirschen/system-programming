; File: STRNGPRN.ASM
;
; Uses a macro to print three strings to the screen.

ORG  0x100
BITS 16

%macro PRINT_STRING 1
    MOV DX, %1       ; Move parameter to register DX for printing
    MOV AH, 9        ; Use function for printing a string to the screen
    INT 0x21         ; Print string
%endmacro

PRINT_STRING HEADER
PRINT_STRING CHAP1
PRINT_STRING CHAP2

MOV AH, 0x4C         ; Use function for quitting the program
INT 0x21             ; Quit

HEADER DB "Assembly Programming", 10, 13, "$"
CHAP1 DB "Chapter 1: Register Operations", 10, 13, "$"
CHAP2 DB "Chapter 2: Stack Operations", 10, 13, "$"
