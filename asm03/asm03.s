section .data
    good db "42", 0
    msg  db "1337", 0x0A
    msglen equ $ - msg

section .text
    global main

main:
    cmp rdi, 2
    jne fail

    mov rbx, rsi
    mov rbx, [rbx+8]

    mov rsi, good

compare_loop:
    mov al, [rbx]
    mov dl, [rsi]
    cmp al, dl
    jne fail
    test al, al
    je success
    inc rbx
    inc rsi
    jmp compare_loop

success:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, msglen
    syscall

    xor eax, eax
    ret

fail:
    mov eax, 1
    ret
