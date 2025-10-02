section .bss
    data_buf resb 1024

section .data
    newline db 10

section .text
    global _start

_start:
    cmp byte [rsp], 2
    jne exit_failure

    mov rsi, [rsp+16]
    call str_to_int
    mov r12, rax

    mov rax, 0
    mov rdi, 0
    mov rsi, data_buf
    mov rdx, 1024
    syscall
    mov r13, rax

    mov r14, data_buf
    lea r15, [data_buf + r13]
.encode_loop:
    cmp r14, r15
    jge .end_encode

    movzx rax, byte [r14]

    cmp al, 'a'
    jl .check_upper
    cmp al, 'z'
    jg .check_upper

    add al, r12b
    cmp al, 'z'
    jle .apply
    sub al, 26
    jmp .apply

.check_upper:
    cmp al, 'A'
    jl .next_char
    cmp al, 'Z'
    jg .next_char

    add al, r12b
    cmp al, 'Z'
    jle .apply
    sub al, 26

.apply:
    mov [r14], al

.next_char:
    inc r14
    jmp .encode_loop

.end_encode:
    mov rax, 1
    mov rdi, 1
    mov rsi, data_buf
    mov rdx, r13
    syscall

exit_success:
    mov rax, 60
    xor rdi, rdi
    syscall

exit_failure:
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
    xor rbx, rbx
.loop:
    mov bl, [rsi]
    cmp bl, 0
    je .done
    sub bl, '0'
    imul rax, 10
    add rax, rbx
    inc rsi
    jmp .loop
.done:
    ret
