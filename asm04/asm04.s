section .bss
    num resb 16

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 16
    syscall
    mov rcx, rax
    xor rbx, rbx
    xor rdx, rdx

validate_loop:
    cmp rdx, rcx
    je done_convert
    mov al, [num+rdx]
    cmp al, 10
    je done_convert
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input
    sub al, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rdx
    jmp validate_loop

done_convert:
    test rbx, 1
    jz even
    mov rax, 60
    mov rdi, 1
    syscall

even:
    mov rax, 60
    xor rdi, rdi
    syscall

invalid_input:
    mov rax, 60
    mov rdi, 2
    syscall
