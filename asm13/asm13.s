section .bss
    tampon resb 1024

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, tampon
    mov rdx, 1024
    syscall

    mov r13, rax
    test r13, r13
    jz etiquet_palindrome
    
    dec r13
.nettoyage_nouvelles_lignes:
    cmp r13, 0
    jl etiquet_palindrome
    mov al, [tampon+r13]
    cmp al, 10
    je .decremente_et_continue
    cmp al, 13
    je .decremente_et_continue
    jmp .demarrer_verif
.decremente_et_continue:
    dec r13
    jmp .nettoyage_nouvelles_lignes

.demarrer_verif:
    mov rsi, tampon
    mov rdi, tampon
    add rdi, r13

.boucle_verif:
    cmp rsi, rdi
    jge etiquet_palindrome

    mov al, [rsi]
    mov bl, [rdi]
    cmp al, bl
    jne etiquet_non_palindrome

    inc rsi
    dec rdi
    jmp .boucle_verif

etiquet_palindrome:
    mov rax, 60
    xor rdi, rdi
    syscall

etiquet_non_palindrome:
    mov rax, 60
    mov rdi, 1
    syscall
