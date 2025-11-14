; Boot sector code - loaded by BIOS at address 0x7c00
[ORG 0x7c00]
[SECTION .text]
[BITS 16]  ; 16-bit mode
global _start

_start:
    ; Clear screen using BIOS interrupt 0x10, function 0x00 (set video mode)
    ; Mode 3 = 80x25 text mode, 16 colors
    mov ax, 3
    int 0x10

    ; Initialize all segment registers to 0
    ; This ensures we're working with absolute addresses starting from 0x7c00
    mov ax, 0
    mov ss, ax      ; Stack segment
    mov ds, ax      ; Data segment
    mov es, ax      ; Extra segment
    mov fs, ax      ; FS segment
    mov gs, ax      ; GS segment
    mov si, ax      ; Initialize SI (Source Index) to 0

    ; Load the address of the message string into SI
    mov si, msg

    ; Call the print function to display the message
    call print

    ; Infinite loop - halt execution here
    ; $ = current address, so this jumps to itself forever
    jmp $


; Print function: displays a null-terminated string using BIOS interrupt 0x10
print:
    ; Set up BIOS teletype output function
    mov ah, 0x0e    ; Function 0x0e = Write character in teletype mode
    mov bh, 0       ; Page number (0 = current page)
    mov bl, 0x01    ; Color/attribute (0x01 = blue on black)

.loop:
    ; Load the current character from the string into AL
    mov al, [si]
    ; Check if we've reached the null terminator (0)
    cmp al, 0
    jz .done        ; If zero, jump to done
    ; Print the character using BIOS interrupt
    int 0x10

    ; Move to the next character in the string
    inc si
    jmp .loop       ; Continue looping

.done:
    ret             ; Return from function

; Message string: "Hello, World!" followed by newline (10), carriage return (13), and null terminator (0)
msg:
    db "Hello, World!", 10, 13, 0

; Pad the boot sector to 510 bytes (boot sector must be exactly 512 bytes)
; Fill remaining space with zeros
times 510 - ($ - $$) db 0
; Boot signature: must be 0x55 0xAA at bytes 511-512 for BIOS to recognize as bootable
db 0x55, 0xaa