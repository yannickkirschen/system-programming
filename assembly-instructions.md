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
carriage return (ASCII 10 and 13) and a string end symbol $.

A line feed can be declared as `LINEFEED DB 10, 13, "$"`.

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
