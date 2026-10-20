section .data
    msg_title   db 0xA, "--- MODULO 1: IDENTIFICACION DEL CPU ---", 0xA, 0
    msg_brand   db "Procesador: ", 0
    msg_ext     db 0xA, "Extensiones detectadas: ", 0
    msg_sse     db "SSE ", 0
    msg_sse2    db "SSE2 ", 0
    msg_avx     db "AVX ", 0
    msg_avx2    db "AVX2 ", 0
    msg_avx512  db "AVX-512 ", 0
    msg_newline db 0xA, 0

section .bss
    brand_string resb 64    ; Espacio para el nombre del procesador (48 bytes + margen)

section .text
    global print_cpu_info
    extern print_string     ; Función aux para imprimir texto

print_cpu_info:
    push rbp
    mov rbp, rsp

    ; Imprimir título del módulo
    mov rdi, msg_title
    call print_string

    ; -------------------------------------------------------------
    ; 1. Obtener Nombre Comercial (Brand String)
    ; -------------------------------------------------------------
    mov rdi, msg_brand
    call print_string

    mov rdi, brand_string   ; Apuntador donde guardaremos el texto
    
    ; Parte 1: 0x80000002
    mov eax, 0x80000002
    cpuid
    mov [rdi], eax
    mov [rdi+4], ebx
    mov [rdi+8], ecx
    mov [rdi+12], edx

    ; Parte 2: 0x80000003
    mov eax, 0x80000003
    cpuid
    mov [rdi+16], eax
    mov [rdi+20], ebx
    mov [rdi+24], ecx
    mov [rdi+28], edx

    ; Parte 3: 0x80000004
    mov eax, 0x80000004
    cpuid
    mov [rdi+32], eax
    mov [rdi+36], ebx
    mov [rdi+40], ecx
    mov [rdi+44], edx

    mov byte [rdi+48], 0    ; Carácter nulo final

    ; Imprimir el nombre comercial
    mov rdi, brand_string
    call print_string

    ; -------------------------------------------------------------
    ; 2. Detectar Extensiones (SSE, SSE2, AVX, AVX2, AVX-512)
    ; -------------------------------------------------------------
    mov rdi, msg_ext
    call print_string

    ; Consulta EAX=1 para SSE, SSE2, AVX
    mov eax, 1
    cpuid
    
    push rcx                ; Guardar ECX
    push rdx                ; Guardar EDX

    ; Probar SSE (EDX bit 25)
    bt edx, 25
    jnc .check_sse2
    mov rdi, msg_sse
    call print_string

.check_sse2:
    pop rdx
    push rdx
    ; Probar SSE2 (EDX bit 26)
    bt edx, 26
    jnc .check_avx
    mov rdi, msg_sse2
    call print_string

.check_avx:
    pop rdx
    pop rcx
    ; Probar AVX (ECX bit 28)
    bt ecx, 28
    jnc .check_extended
    mov rdi, msg_avx
    call print_string

.check_extended:
    ; Consulta EAX=7, ECX=0 para AVX2 y AVX-512
    mov eax, 7
    xor ecx, ecx
    cpuid

    push rbx

    ; Probar AVX2 (EBX bit 5)
    bt ebx, 5
    jnc .check_avx512
    mov rdi, msg_avx2
    call print_string

.check_avx512:
    pop rbx
    ; Probar AVX-512F (EBX bit 16)
    bt ebx, 16
    jnc .done
    mov rdi, msg_avx512
    call print_string

.done:
    mov rdi, msg_newline
    call print_string

    mov rsp, rbp
    pop rbp
    ret
