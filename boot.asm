[bits 16]


start:
    ; Set up the stack
    xor ax, ax
    mov ss, ax
    mov sp, 0x7C00

    ; Reset disk system
    mov ah, 0x00
    int 0x13
    jc disk_error

    ; Load root directory into memory
    mov ax, 0x0200
    mov bx, 0x7E00
    mov cx, 0x0020
    mov dx, 0x0000
    int 0x13
    jc disk_error

    ; Search for keyboard.bin in the root directory
    mov di, 0x7E00

search_loop:
    cmp word [di], 0x0000
    je file_not_found
    cmp byte [di+11], 0x0F
    je next_entry
    mov si, filename
    mov cx, 11
    rep cmpsb
    je file_found

next_entry:
    add di, 32
    jmp search_loop

file_found:
    ; Load the first sector of the file into memory
    mov ax, 0x0200
    mov bx, 0x8000
    mov cx, word [di+0x1A]
    xor dx, dx
    int 0x13
    jc disk_error

    ; Jump to the loaded sector
    jmp 0x8000

disk_error:
    mov si, disk_error_msg
    jmp print_string

file_not_found:
    mov si, file_not_found_msg
    jmp print_string

print_string:
    lodsb
    or al, al
    jz done
    mov ah, 0x0E
    int 0x10
    jmp print_string

done:
    hlt

filename db 'KEYBOARD BIN'
disk_error_msg db 'Disk error', 0
file_not_found_msg db 'File not found', 0

; We have to put this boot signature at the end of the boot sector
times 510-($-$$) db 0
dw 0xAA55
