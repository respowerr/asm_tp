section .bss
    buffer resb 32

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, buffer
    mov rdx, 32
    syscall

    xor rbx, rbx
    mov rsi, buffer
.convert:
    mov al, [rsi]
    cmp al, 10
    je .done_convert
    cmp al, '0'
    jb .invalid
    cmp al, '9'
    ja .invalid
    sub al, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rsi
    jmp .convert
.done_convert:

    cmp rbx, 2
    jb not_prime

    mov rcx, 2
.check_loop:
    mov rax, rbx
    xor rdx, rdx
    div rcx
    cmp rdx, 0
    je not_prime

    inc rcx
    mov rax, rcx
    imul rax, rax
    cmp rax, rbx
    jbe .check_loop

    mov rax, 60
    xor rdi, rdi
    syscall

not_prime:
    mov rax, 60
    mov rdi, 1
    syscall

.invalid:
    mov rax, 60
    mov rdi, 2
    syscall
