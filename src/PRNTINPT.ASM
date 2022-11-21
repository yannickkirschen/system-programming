; File: PRNTINPT.ASM
;
; Lets the user type an arbitrary number of characters that get written to the
; screen immediately. When the user presses <ESC>, the programm quits.

ORG  0x100
BITS 16

INPUT:
    MOV AH, 0x8    ; Use function for input without echo
    INT 0x21       ; Execute input

    CMP AL, 0x1B   ; Check if input is <ESC>
    JE END         ; Goto END if input is <ESC>

    MOV DL, AL     ; Put input character into register for output
    MOV AH, 0x2    ; Use function for output on screen
    INT 0x21       ; Execute output

    JMP INPUT      ; Loop back to input

END:
    MOV AH, 0x4C   ; Use function for quiting the program
    INT 0x21       ; Quit
