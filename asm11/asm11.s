section .bss
    buf_in   resb 256
    buf_out  resb 32

section .text
    global _start

_start:
    mov     rax, 0
    mov     rdi, 0
    mov     rsi, buf_in
    mov     rdx, 256
    syscall

    xor     r9d, r9d
    xor     rbx, rbx
count_loop:
    cmp     rbx, rax
    jge     done_count
    movzx   rdx, byte [buf_in + rbx]
    cmp     rdx, 10
    je      done_count
    cmp     dl, 'a'
    je      inc_v
    cmp     dl, 'e'
    je      inc_v
    cmp     dl, 'i'
    je      inc_v
    cmp     dl, 'o'
    je      inc_v
    cmp     dl, 'u'
    je      inc_v
    cmp     dl, 'y'
    je      inc_v
    cmp     dl, 'A'
    je      inc_v
    cmp     dl, 'E'
    je      inc_v
    cmp     dl, 'I'
    je      inc_v
    cmp     dl, 'O'
    je      inc_v
    cmp     dl, 'U'
    je      inc_v
    cmp     dl, 'Y'
    jne     next_ch
inc_v:
    inc     r9
next_ch:
    inc     rbx
    jmp     count_loop

done_count:
    mov     rax, r9
    lea     rsi, [rel buf_out]
    call    u64_to_str_nl

    mov     rax, 1
    mov     rdi, 1
    syscall

    mov     rax, 60
    xor     rdi, rdi
    syscall

u64_to_str_nl:
    mov     rdi, rsi
    add     rdi, 32
    xor     rbx, rbx
    test    rax, rax
    jnz     conv_loop
    dec     rdi
    mov     byte [rdi], '0'
    mov     rbx, 1
    jmp     finish
conv_loop:
    xor     rdx, rdx
    mov     r9, 10
    div     r9
    dec     rdi
    add     dl, '0'
    mov     [rdi], dl
    inc     rbx
    test    rax, rax
    jnz     conv_loop
    
finish:
    mov     byte [rdi+rbx], 10
    inc     rbx
    mov     rsi, rdi
    mov     rdx, rbx
    ret
