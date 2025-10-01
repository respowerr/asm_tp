section .data
    texte db "Hello Universe!", 10
    taille equ $ - texte

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne fin_echec

    mov rax, 2
    mov rdi, [rsp+16]
    mov rsi, 65
    mov rdx, 0644o
    syscall

    cmp rax, 0
    jl fin_echec

    mov rbx, rax

    mov rax, 1
    mov rdi, rbx
    mov rsi, texte
    mov rdx, taille
    syscall

    mov rax, 3
    mov rdi, rbx
    syscall

    jmp fin_succes

fin_echec:
    mov rax, 60
    mov rdi, 1
    syscall

fin_succes:
    mov rax, 60
    xor rdi, rdi
    syscall
