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

    mov rbx, 0
    mov rcx, 0
convert_loop:
    mov al, [num+rcx]
    cmp al, 10
    je done_convert
    cmp al, 0
    je done_convert
    sub al, '0'
    imul rbx, rbx, 10
    add rbx, rax
    inc rcx
    jmp convert_loop
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
