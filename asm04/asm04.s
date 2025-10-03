section .bss
    num resb 32

section .text
    global _start

_start:
    mov rax, 0
    mov rdi, 0
    mov rsi, num
    mov rdx, 32
    syscall
    mov rcx, rax
    xor rbx, rbx
    xor rdx, rdx
    mov r8, 0

validate_loop:
    cmp rdx, rcx
    je done_convert
    mov al, [num+rdx]
    cmp al, 10
    je done_convert
    cmp rdx, 0
    jne not_first
    cmp al, '-'
    jne not_first
    mov r8, 1
    inc rdx
    jmp validate_loop
not_first:
    cmp al, '0'
    jb invalid_input
    cmp al, '9'
    ja invalid_input
    sub al, '0'
    movzx rax, al
    imul rbx, rbx, 10
    add rbx, rax
    cmp rbx, 0x7FFFFFFF
    jg invalid_input
    inc rdx
    jmp validate_loop

done_convert:
    cmp r8, 0
    je check_parity
    neg rbx

check_parity:
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
