section .bss
    buffer resb 32

section .data
    nl db 10

section .text
    global _start

_start:
    mov rax, [rsp]
    cmp rax, 4
    jne fail_exit           

    mov rsi, [rsp+16]       
    call str_to_int
    mov rbx, rax

    mov rsi, [rsp+24]       
    call str_to_int
    cmp rax, rbx
    jle .skip2
    mov rbx, rax
.skip2:

    mov rsi, [rsp+32]       
    call str_to_int
    cmp rax, rbx
    jle .skip3
    mov rbx, rax
.skip3:

    mov rax, rbx
    mov rdi, buffer
    mov rdx, 10             
    call int_to_base

    mov rdx, rax            
    mov rax, 1
    mov rdi, 1
    mov rsi, buffer
    syscall

    mov rax, 1
    mov rdi, 1
    mov rsi, nl
    mov rdx, 1
    syscall

    mov rax, 60
    xor rdi, rdi
    syscall

fail_exit:
    mov rax, 60
    mov rdi, 1
    syscall

str_to_int:
    xor rax, rax
.next_char:
    mov dl, [rsi]
    cmp dl, 0
    je .done
    sub dl, '0'
    imul rax, rax, 10
    add rax, rdx
    inc rsi
    jmp .next_char
.done:
    ret

int_to_base:
    mov rcx, rdi
    mov r8, rdx
    add rdi, 31
    mov byte [rdi], 0
    dec rdi
.convert_loop:
    xor rdx, rdx
    div r8 
    mov r10b, dl
    cmp r10b, 10
    jb .digit
    add r10b, 'A' - 10
    jmp .store
.digit:
    add r10b, '0'
.store:
    mov [rdi], r10b
    dec rdi
    test rax, rax
    jnz .convert_loop
    inc rdi
    mov rsi, rdi
    mov rdi, rcx
    mov rcx, 32
    rep movsb
    mov rax, rsi
    sub rax, rdi
    ret