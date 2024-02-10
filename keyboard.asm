section .data
    ESC_KEY EQU 1BH        ; ASCII code for the ESC key
    KB_DATA EQU 60H         ; 8255 port PA (keyboard data)

section .text
global _start

_start:
    key_up_loop:
        ; Loops until a key is pressed (PA7 = 0)
        ; PA7 = 1 if a key is up.
        in AL, KB_DATA          ; Read keyboard status & scan code
        test AL, 80H            ; Check if PA7 = 0
        jnz key_up_loop         ; If not, loop back
        and AL, 7FH             ; Isolate the scan code

        ; Translate scan code to ASCII code in AL
        ; (You'd need a lookup table or more complex logic here)

        cmp AL, 0               ; Uninterested key (e.g., function keys)
        je key_up_loop

        cmp AL, ESC_KEY         ; ESC key terminates the program
        je done

        ; Display the character in AL to the screen
        ; (You'd need to implement this part)

    key_down_loop:
        in AL, KB_DATA          ; Read keyboard status & scan code
        test AL, 80H            ; Check if PA7 = 1
        jz key_down_loop        ; If not, loop back

        ; Clear the keyboard buffer
        mov AX, 0C00H
        int 21H                 ; System interrupt

        jmp key_up_loop

done:
    ; Clear the keyboard buffer again
    mov AX, 0C00H
    int 21H

    ; Exit the program (you'd need to implement this part)

