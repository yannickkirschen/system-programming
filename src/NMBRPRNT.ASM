; File: NMBRPRNT.ASM
;
; Prints the numbers from 4 to 6 on the screen.

ORG  0x100
BITS 16

MOV DL, '4'         ; Initialize with 4

WRITE:
    MOV AH, 2       ; Use function for output on screen
    INT 0x21        ; Execute output

    CMP DL, '6'     ; Compare number with 6
    JE  END         ; Go to END if number is 6

    INC DL          ; Else: increment number
    JMP WRITE       ; Write again

END:
    MOV AH, 0x4C    ; Use function for quiting the program
    INT 0x21        ; Quit
