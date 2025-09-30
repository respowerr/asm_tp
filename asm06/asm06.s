section .bss
    output_buffer resb 20

section .data
    newline db 10

section .text
    global _start

_start:
    cmp byte [rsp], 3
    jne fail_exit

    mov rsi, [rsp+16]
    call str_to_int
    mov r14, rax

    mov rsi, [rsp+24]
    call str_to_int
    mov r15, rax

    add r14, r15

    mov rax, r14
    mov rdi, output_buffer
    call int_to_str

    mov rdx, rax
    mov rax, 1
    mov rdi, 1
    mov rsi, output_buffer
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, newline
    mov rdx, 1
    syscall

success_exit:
    mov rax, 60
    xor rdi, rdi
    syscall

fail_exit:
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
    xor rcx, rcx
    mov rbx, 1

    cmp byte [rsi], '-'
    jne .parse_loop
    mov rbx, -1
    inc rsi

.parse_loop:
    mov cl, [rsi]
    cmp cl, 0
    je .finish
    sub cl, '0'
    imul rax, 10
    add rax, rcx
    inc rsi
    jmp .parse_loop
.finish:
    imul rax, rbx
    ret

int_to_str:
    mov r10, rdi
    mov r11, 10
    mov r12, 0

    test rax, rax
    jns .convert_loop
    neg rax
    mov r12, 1

.convert_loop:
    add rdi, 19
    mov byte [rdi], 0
    dec rdi
.digit_loop:
    xor rdx, rdx
    div r11
    add dl, '0'
    mov [rdi], dl
    dec rdi
    test rax, rax
    jnz .digit_loop

    cmp r12, 1
    jne .prepare_copy
    mov byte [rdi], '-'
    dec rdi

.prepare_copy:
    inc rdi
    mov rdx, r10
    add rdx, 20
    sub rdx, rdi
    mov rax, rdx

    mov rcx, rax
    mov rsi, rdi
    mov rdi, r10
    rep movsb
    ret
