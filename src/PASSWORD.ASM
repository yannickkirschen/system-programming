; File: PASSWORD.ASM
;
; Check an input password with a predefined password. The user has three tries.

ORG  0x100
BITS 16

%macro PRINT_STRING 1
    MOV DX, %1
    MOV AH, 9
    INT 0x21
%endmacro

%macro STRING_LENGTH 2
    MOV SI, %1                       ; Reference of string to check (first element)
    MOV BX, SI                       ; Load address of first character to BX

    %%LENGTH_LOOP:
        CMP BYTE[SI], '$'            ; Is the current character the string end character?
        JE %%CALCULATE               ; Calculate length of string if end of string is reached

        INC SI                       ; Increase string index (will be the character in next loop)
        JMP %%LENGTH_LOOP            ; Loop until end of string is reached

    %%CALCULATE:
        MOV AX, SI                   ; Load index of last character to AX
        SUB AX, BX                   ; Subtract index of first character (this will result in the length)
        MOV BYTE[%2], AL             ; Write length to variable
%endmacro

%macro STRING_COMPARE 2
    PUSH AX                          ; Save data in AX

    MOV AL, BYTE[INPUT_LENGTH]       ; Load length of input string
    MOV AH, BYTE[PASSWORD_LENGTH]    ; Load length of password string
    CMP AL, AH                       ; Compare length of strings
    JNE %%NOT_IDENTICAL              ; The strings cannot be equal

    MOV SI, %1                       ; Reference of source string (first element)
    MOV DI, %2                       ; Reference of target string (first element)

    MOV CL, BYTE[INPUT_LENGTH]       ; Load length of password into CL (will be the number of loops)

    ; Alternative:
    ; MOV AL, 0
    XOR AL, AL                       ; Erase potential data in AL

    %%MAIN_LOOP:
        MOV AL, BYTE[SI]             ; Load source character
        MOV BL, BYTE[DI]             ; Load target character

        CMP AL, BL                   ; Compares both characters
        JNE %%NOT_IDENTICAL          ; The characters are not equal

        INC SI                       ; Increase source index (will be the character in next loop)
        INC DI                       ; Increase target index (will be the character in next loop)
        LOOP %%MAIN_LOOP             ; Loop unless characters are not equal

        MOV BYTE[IS_EQUAL], 1        ; Strings are equal (=1)
        JMP %%END                    ; All characters are identical

    %%NOT_IDENTICAL:
        MOV BYTE[IS_EQUAL], 0        ; Strings are not equal (=0)

    %%END:
%endmacro

STRING_LENGTH PASSWORD, PASSWORD_LENGTH

MAIN_LOOP:
    MOV BYTE[INPUT_LENGTH], 0        ; Reset password length
    INC BYTE[TRIES]                  ; Increment tries

    CMP BYTE[TRIES], 3               ; Check, if we exceeded three tries
    JG GAME_OVER                     ; End, if we exceeded three tries

    MOV CX, 10                       ;
    MOV SI, INPUT                    ; Reference of input string (first element)
    PRINT_STRING MESSAGE_PROMPT

    MOV DL, BYTE[TRIES]              ; Load tries
    ADD DL, 0x30                     ; Mask tries for output (ASCII)

    MOV AH, 2                        ; Use function for printing a single character on the screen
    INT 0x21                         ; Execute output (print tries)
    PRINT_STRING LINE_FEED

INPUT_LOOP:
    MOV AH, 8                        ; Use function for input without printing
    INT 0x21                         ; Execute input

    CMP AL, 13                       ; Input has been written to AL. Check if <ENTER> has been pressed
    JE CHECK_INPUT                   ; Check input if <ENTER> has been pressed

    PUSH AX                          ;
    MOV DL, '*'                      ; We want to write an asterisk instead of the input character

    MOV AH, 2                        ; Use function for printing a single character on the screen
    INT 0x21                         ; Execute output

    POP AX                           ; Restore data from AX
    MOV BYTE[SI], AL                 ; Load input to string variable
    INC SI                           ; Increment SI to load the next character at the next position

    LOOP INPUT_LOOP                  ; Loop until <ENTER> is pressed

CHECK_INPUT:
    MOV BYTE[SI], "$"                ; Add end of string character to input string

    STRING_LENGTH INPUT, INPUT_LENGTH
    MOV BH, BYTE[INPUT_LENGTH]       ; Load length of input string
    CMP BH, BYTE[PASSWORD_LENGTH]    ; Is the input length of the same length as the password?
    JNE PRINT_NO                     ; Print password incorrect message if both strings are not of the same length

    STRING_COMPARE PASSWORD, INPUT   ; Compare input and password string
    CMP BYTE[IS_EQUAL], 1            ; Check if strings are equal
    JNE PRINT_NO                     ; Print password incorrect message if strings are not equal

    PRINT_STRING LINE_FEED
    PRINT_STRING MESSAGE_CORRECT
    JMP END                          ; The password is correct

PRINT_NO:
    PRINT_STRING LINE_FEED
    PRINT_STRING MESSAGE_WRONG
    JMP MAIN_LOOP                    ; Loop back to main loop

GAME_OVER:
    PRINT_STRING MESSAGE_OVER
    PRINT_STRING LINE_FEED

END:
    MOV AH, 0x4C                     ; Use function for quitting the program
    INT 0x21                         ; Quit

INPUT_LENGTH    DB 0                 ; Length of the password
PASSWORD_LENGTH DB 0                 ; Length of input

PASSWORD        DB "pw123$"          ; Stored password
INPUT           DB "**********$"     ; Input by the user

TRIES           DB 0                 ; Number of tries
IS_EQUAL        DB 2                 ; Equal: 1,  Not equal: 0

MESSAGE_PROMPT  DB "Enter password. Try No. $"
MESSAGE_WRONG   DB "Password wrong!", 10, 13, "$"
MESSAGE_CORRECT DB "Password correct.$"
MESSAGE_OVER    DB "Password wrong 3 times in a row - you are dumb!$"

LINE_FEED       DB 10, 13, "$"
