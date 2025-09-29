section .data
    msg db "1337", 0x0A
    len equ $ - msg

section .text
    global _start

_start:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, len      
    syscall

    ; exit(0)
    xor rdi, rdi
    mov rax, 60
    syscall
