[ORG 0x7c00]
[SECTION .text]
[BITS 160]
global _start

_start:
    ;
    mov ax, 3
    int 0x10

    mov ax, 0
    mov ss, ax
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov si, ax

    mov si, msg

    call print

    jmp $


print:
    mov ah, 0x0e
    mov bh, 0
    



