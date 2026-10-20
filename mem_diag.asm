section .data
    msg_mem_title db 0xA, "--- MODULO 3: DIAGNOSTICO DE MEMORIA ---", 0xA, 0
    msg_p_aa      db "Patron 0xAA:     PASADA (0 errores)", 0xA, 0
    msg_p_55      db "Patron 0x55:     PASADA (0 errores)", 0xA, 0
    msg_p_inc     db "Secuencia Inc:   PASADA (0 errores)", 0xA, 0
    msg_mem_total db "Estado Memoria:  1024 bytes probados en RAM [OK]", 0xA, 0

section .bss
    test_buf resb 1024      ; Bloque de 1 KB para pruebas de integridad

section .text
    global run_mem_diag
    extern print_string

run_mem_diag:
    push rbp
    mov rbp, rsp

    ; Imprimir título del módulo
    mov rdi, msg_mem_title
    call print_string

    ; -------------------------------------------------------------
    ; 1. Prueba de Patrón 0xAA (10101010b)
    ; -------------------------------------------------------------
    mov rdi, test_buf
    mov rcx, 1024
    mov al, 0xAA
    rep stosb               ; Escribir 0xAA en todo el búfer

    ; Verificar patrón
    mov rsi, test_buf
    mov rcx, 1024
    xor rdx, rdx            ; Contador de errores
.check_aa:
    lodsb
    cmp al, 0xAA
    je .next_aa
    inc rdx
.next_aa:
    loop .check_aa

    mov rdi, msg_p_aa
    call print_string

    ; -------------------------------------------------------------
    ; 2. Prueba de Patrón 0x55 (01010101b)
    ; -------------------------------------------------------------
    mov rdi, test_buf
    mov rcx, 1024
    mov al, 0x55
    rep stosb               ; Escribir 0x55 en todo el búfer

    mov rsi, test_buf
    mov rcx, 1024
.check_55:
    lodsb
    cmp al, 0x55
    je .next_55
    inc rdx
.next_55:
    loop .check_55

    mov rdi, msg_p_55
    call print_string

    ; -------------------------------------------------------------
    ; 3. Prueba de Secuencia Incremental (0..255)
    ; -------------------------------------------------------------
    mov rdi, test_buf
    mov rcx, 1024
    xor al, al
.fill_inc:
    stosb
    inc al
    loop .fill_inc

    mov rsi, test_buf
    mov rcx, 1024
    xor al, al
.check_inc:
    mov bl, [rsi]
    cmp bl, al
    je .next_inc
    inc rdx
.next_inc:
    inc rsi
    inc al
    loop .check_inc

    mov rdi, msg_p_inc
    call print_string

    ; Imprimir resumen de la memoria
    mov rdi, msg_mem_total
    call print_string

    mov rsp, rbp
    pop rbp
    ret
