
section .text
    global _start

_start:
    mov rbx, rsp
    mov rax, [rbx]
    cmp rax, 2
    jne exit_fail
    mov rsi, [rbx + 16]
    xor rcx, rcx
strlen_loop:
    cmp byte [rsi + rcx], 0
    je strlen_done
    inc rcx
    jmp strlen_loop
strlen_done:
    mov rax, 1
    mov rdi, 1
    mov rdx, rcx
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

exit_fail:
    mov rax, 60
    mov rdi, 1
    syscall
