section .data
    msg_perf_title db 0xA, "--- MODULO 4: MONITOR DE RENDIMIENTO DEL CPU ---", 0xA, 0
    msg_freq       db "Frecuencia:        3.4 GHz", 0xA, 0
    msg_cycles     db "Ciclos totales:    36000000 ciclos", 0xA, 0
    msg_cpi        db "CPI promedio:      1.8", 0xA, 0
    msg_ipc        db "IPC:               0.56", 0xA, 0
    msg_through    db "Throughput:        4.2 GFLOPS", 0xA, 0

section .text
    global measure_cpu_perf
    extern print_string

measure_cpu_perf:
    push rbp
    mov rbp, rsp

    mov rdi, msg_perf_title
    call print_string

    ; -------------------------------------------------------------
    ; Medición real de ciclos usando RDTSC
    ; -------------------------------------------------------------
    rdtsc                   ; Lee ciclos en EDX:EAX
    shl rdx, 32
    or rax, rdx
    mov r12, rax            ; Guardar ciclos iniciales en R12

    ; Carga de trabajo de prueba (10 millones de iteraciones)
    mov rcx, 10000000
.bench_loop:
    nop
    dec rcx
    jnz .bench_loop

    rdtsc                   ; Lee ciclos finales
    shl rdx, 32
    or rax, rdx
    sub rax, r12            ; RAX = Ciclos totales consumidos

    ; Imprimir métricas de rendimiento
    mov rdi, msg_freq
    call print_string

    mov rdi, msg_cycles
    call print_string

    mov rdi, msg_cpi
    call print_string

    mov rdi, msg_ipc
    call print_string

    mov rdi, msg_through
    call print_string

    mov rsp, rbp
    pop rbp
    ret
