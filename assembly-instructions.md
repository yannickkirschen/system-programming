# Assembly Instructions

These are the relevant assembly instructions for the 8086 we use in the lecture.

## Program Structure

Every program must start with the following two lines:

```asm
ORG  0x100
BITS 16
```

After that comes the code and finally the data.

## Registers

Registers are 16 bits wide and have the names A-D. When we want to use the full
16 bits, we have to append an X, so the registers are called `AX`, `BX`, `CX`,
`DX`.

Registers can be divided into two 8-bit parts. We call the higher register `H`
and the lower register `L`, resulting in the register names `AH`, `BH`, `CH`,
`DH` and `AL`, `BL`, `CL`, `DL`.

Here is a list and purpose of all four registers:

| Name | Description                                    |
|------|------------------------------------------------|
| `AX` | *Accumulator*: Used for arithmetic operations. |
| `BX` | *Basis*: Used for addressing values in memory. |
| `CX` | *Counter*: Used as counter in loops.           |
| `DX` | Used for addressing as well.                   |

## Functions

Functions get written into `AH`:

`MOV AH, <NUMBER>`

and triggered by using the interrupt `21H`:

`INT 21H`

| Number | Description                                                                                   |
|--------|-----------------------------------------------------------------------------------------------|
| `1`    | Keyboard input *with* output of the character (see [Keyboard Input](#keyboard-input)).        |
| `8`    | Keyboard input *without* output of the character (see [Keyboard Input](#keyboard-input)).     |
| `2`    | Print a single character onto the screen (see [Output of characters](#output-of-characters)). |
| `0x4C` | Quit the program.                                                                             |
| `0x9C` | Print a string onto the screen (see [Strings](#strings)).                                     |

## Keyboard Input

A keyboard input is written to register `AL`.

```asm
MOV AH, 0x1      ; Use function for input (alternative: 8)
INT 0x21         ; Wait for input
CMP AL, <VALUE>  ; Compare input with <VALUE>

; Optional:
JE <LABEL>       ; Jump to <LABEL> if comparison returned true
```

## Output of Characters

To print a character to the screen, it needs to be written to register `DL` first:

`MOV DL, <VALUE>`

After that, it can be printed:

```asm
MOV AH, 0x2 ; Use function for output
INT 0x21    ; Trigger output
```

For printing a string (as described in [Strings](#strings)), use:

```asm
MOV DX, <STRING_NAME> ; Move reference to register DX for printing
MOV AH, 9             ; Use function for printing a string to the screen
INT 0x21              ; Print string
```

## Variables

Variables can be declared either as 8 bit or 16 bit. The declaration must be
placed at the end of the program.

- 8-bit: `<VARIABLE> DB <VALUE>` (*define byte*)
- 16-bit: `<VARIABLE> DW <VALUE>` (*define word*)

Data can be put into the variable by using `MOV WORD[<VARIABLE>], <DATA>`.
This is like a reference in high-level programming languages.

Example:

```asm
MOV WORD[MY_VAR], BX ; Write content of BX register into MY_VAR

MY_VAR DW 0          ; Declares an 16-bit variable called MY_VAR with initial value 0
```

## Arrays

Array can be declared like so:

```asm
<NAME>: TIMES <LENGTH> DB/DW <INITIAL VALUE>
```

To give an example: `ARRAY: TIMES 5 DB 0` creates an array called ARRAY with a
length of five and initializes all elements with 0.

## Strings

Strings can be declared like so:

```asm
<NAME> DB "<TEXT>", 10, 13, "$"
```

The declaration must be placed at the end of the program. The last three options
define how the end of the string should look like. In this case, we want a
carriage return (ASCII 10 and 13) and a string end symbol `$`.

A line feed can be declared as `LINEFEED DB 10, 13, "$"`.

Instead of using the methods described in
[Output of Characters](#output-of-characters) to print a string, you can use
`LODSB` (*Load String Byte*):

```asm
MOV SI, <STRING_NAME> ; Load string offset to SI

OUTPUT:
    LODSB             ; Loads character to AL and increment SI
    MOV DL, AL        ; Load next character
    CMP DL, "$"       ; Check if string end is reached
    JE END            ; Jump to end of end of string is reached

    MOV AH, 2         ; Use function for output on screen
    INT 0x21          ; Execute output
    JMP OUTPUT        ; Loop

END:
    ; Do something here
```

Instead of using the methods described in [Keyboard Input](#keyboard-input) to
read a string from keyboard input, you can use `STOSB (*Store String Byte*):

```asm
MOV DI, <STRING> ; Load string offset to DI (data will be written to that string)

INPUT:
    MOV AH, 1    ; Use function for keyboard input with output of the character
    INT 0x21     ; Execute input
    STOSB        ; Stores AL in [DI] (current character)
    CMP AL, 13   ; Input has been written to AL. Check if <ENTER> has been pressed
    JNE INPUT    ; Loop if <ENTER> has not been pressed

    MOV AL, "$"  ; Override last input (<ENTER>) by string end character
    STOSB        ; Stores AL in [DI] (current character)

END:
    ; Do something here
```

## Shifting and Rotating

There are several instructions for shifting and rotating values.

| Op    | Name                   | Description                                                                                   | Example     |
|-------|------------------------|-----------------------------------------------------------------------------------------------|-------------|
| `SHR` | Shift right            | Shifts all bits to the right by a given number and fills up with zeros from the left.         | `SHR BL, 3` |
| `SHL` | Shift left             | Shifts all bits to the left by a given number and fills up with zeros from the right.         | `SHL BL, 3` |
| `ROR` | Rotate right           | Shifts all bits to the right by a given number and fills up with the same bits from the left. | `ROR BL, 3` |
| `ROL` | Rotate left            | Shifts all bits to the left by a given number and fills up with the same bits from the right. | `ROR BL, 3` |
| `RCL` | Rotate with carry left | Shifts all bits to the left and sets the carry flag to 1 if the shifted bit was a 1.          | `RCL BL, 1` |

## Loops

The `LOOP` instruction uses `CX` as a loop variable. Each loop decreases `CX` by
1 and stops when it is 0. An example for a loop is listed below:

```asm
MOV CX, 10         ; Number of loops
MOV DL, 1          ; Start with 1

MARKER:
    ; Do something with DL
    LOOP MARKER    ; Loop until CX = 0
```

## Subroutines

Subroutines are like jumps, but with the option to return to the caller. So
they behave like functions/methods in other programming lectures. An example
is given below:

```asm
; Do something before calling the routine
CALL MY_ROUTINE    ; Call the routine
; Do something after calling the routine

MY_ROUTINE:
    ; Do something here
    RET    ; Return to the caller
```

## Stacks

There is a stack both for registers and flags. The stack for registers can be
used with `PUSH <REGISTER>` and `POP <TARGET REGISTER>`.

The stack for flags can be used with `PUSHF` and `POPF`. Both instructions apply
for all flags at once.

## Flags

Flags are stored in their own register. It has a width of 16 bit and every bit
(=flag) reflects a specific status after an operation of the processor. A flag
is set when having a value of 1. It is not set when having a value of 0.

The following table lists the relevant flags we use in this lecture.

| Order | Name   | Description                                       | Operation              |
|-------|--------|---------------------------------------------------|------------------------|
| 0     | Carry  | Set, if an overflow occurred.                     | `JC`, `JNC`            |
| 2     | Parity | Set, if number of 1s in the lower 8 bits is even. | `JPE`, `JNP`, `JPO`    |
| 6     | Zero   | Set, if the result of an operation is 0.          | `JZ`/`JE`, `JNE`/`JNZ` |
| 7     | Sign   | Set, if the result of an operation is negative.   | `JS`, `JNS`            |
