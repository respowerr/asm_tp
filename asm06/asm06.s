section .bss
    buf resb 32

section .text
    global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jne exit_fail

    mov rsi, [rbx+16]

    xor rdi, rdi
parse_first:
    mov al, [rsi]
    cmp al, 0
    je exit_fail
    cmp al, '-'
    je parse_second_start
    cmp al, '0'
    jb exit_fail
    cmp al, '9'
    ja exit_fail
    sub al, '0'
    imul rdi, rdi, 10
    add rdi, rax
    inc rsi
    jmp parse_first

parse_second_start:
    inc rsi
    xor rcx, rcx
parse_second:
    mov al, [rsi]
    cmp al, 0
    je compute_sum
    cmp al, '0'
    jb exit_fail
    cmp al, '9'
    ja exit_fail
    sub al, '0'
    imul rcx, rcx, 10
    add rcx, rax
    inc rsi
    jmp parse_second

compute_sum:
    add rdi, rcx
    mov rax, rdi
    mov rbx, 10
    lea rsi, [buf+31]
    mov byte [rsi], 0

itoa_loop:
    xor rdx, rdx
    div rbx
    add dl, '0'
    dec rsi
    mov [rsi], dl
    test rax, rax
    jnz itoa_loop

    mov rax, 1
    mov rdi, 1
    mov rdx, buf+31
    sub rdx, rsi
    mov rsi, rsi
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_fail:
    mov rax, 60
    mov rdi, 1
    syscall
