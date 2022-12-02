; File: STRIN.ASM
;
; Provides a prompt to enter 15 characters and prints those string as well as
; its length as hex.

ORG  0x100
BITS 16

%macro PRINTSTRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

PRINTSTRING PROMPT
PRINTSTRING LINE_FEED

MOV CX, 15                  ; Loop 15 times
MOV DI, TARGET              ; Load string offset to DI (data will be written to that target string)

MAIN_LOOP:
    MOV AH, 1               ; Use function for keyboard input with output of the character
    INT 0x21                ; Execute input
    CMP AL, 13              ; Input has been written to AL. Check if <ENTER> has been pressed
    JE PRINT_LENGTH         ; Print length if <ENTER> has been pressed
    INC BYTE[LENGTH]        ; Increment length counter

    ; Alternative to STOSB:
    ; MOV BYTE[DI], AL
    ; INC DI
    STOSB                   ; Copies AL to [DI] and increments (current character)
    LOOP MAIN_LOOP

PRINT_LENGTH:
    MOV BYTE[DI], '$'       ; We have finished reading the string and add the end character to the target string

    PRINTSTRING LINE_FEED
    PRINTSTRING LINE_FEED
    PRINTSTRING OUTPUT_TEXT
    PRINTSTRING TARGET
    PRINTSTRING LINE_FEED
    PRINTSTRING LENGTH_TEXT

    MOV DL, BYTE[LENGTH]    ; Move length to DL for printing on the screen
    ADD DL, 0x30            ; Mask length ti get ASCII character
    CMP DL, 0x39            ; Check if ASCII length is less equals 9
    JLE OUTPUT              ; If ASCII length is 9 is less equals 9, output length
    ADD DL, 7               ; Else, add 7 and output afterwards, to get A-F hex

OUTPUT:
    MOV AH, 2               ; Use function for printing a single character on the screen
    INT 0x21                ; Execute output
    MOV BYTE[LENGTH], 0     ; Set length to 0

MOV AH, 0x4C                ; Use function for quiting the program
INT 0x21                    ; Quit

LENGTH      DB 0
PROMPT      DB "Input (max 15 characters): $"
OUTPUT_TEXT DB "Input was: $"
LENGTH_TEXT DB "Length is: $"
LINE_FEED   DB 10, 13, "$"
TARGET      DB "................$"
