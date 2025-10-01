section .bss
    buffer resb 5

section .data
    signature db 0x7f, "ELF"

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne fin_echec

    mov rax, 2
    mov rdi, [rsp+16]
    xor rsi, rsi
    syscall

    cmp rax, 0
    jl fin_echec
    mov r13, rax

    mov rax, 0
    mov rdi, r13
    mov rsi, buffer
    mov rdx, 5
    syscall

    mov rax, 3
    mov rdi, r13
    syscall

    mov rsi, buffer
    mov rdi, signature
    mov rcx, 4
    repe cmpsb
    jne fin_echec

    cmp byte [buffer+4], 2
    jne fin_echec

fin_succes:
    mov rax, 60
    xor rdi, rdi
    syscall

fin_echec:
    mov rax, 60
    mov rdi, 1
    syscall
