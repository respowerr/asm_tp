section .data
    out_msg db "1337", 10
    out_len equ $ - out_msg

section .text
    global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jne exit_fail

    mov rsi, [rbx+16]
    mov al, byte [rsi]
    cmp al, '4'
    jne exit_fail
    mov al, byte [rsi+1]
    cmp al, '2'
    jne exit_fail
    mov al, byte [rsi+2]
    cmp al, 0
    jne exit_fail

    mov rax, 1
    mov rdi, 1
    mov rdx, out_len
    mov rsi, out_msg
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_fail:
    mov rax, 60
    mov rdi, 1
    syscall