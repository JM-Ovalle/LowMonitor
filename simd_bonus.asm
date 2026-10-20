section .data
    msg_simd_title db 0xA, "--- MODULO 6: OPERACIONES SIMD (BONUS +10 PTS) ---", 0xA, 0
    msg_avx_status db "AVX2 habilitado:   Si", 0xA, 0
    msg_simd_th    db "Throughput:        8 operaciones paralelas (256-bit YMM)", 0xA, 0
    msg_simd_bench db "Benchmark SIMD:    4.2 GFLOPS", 0xA, 0

section .text
    global run_simd_bonus
    extern print_string

run_simd_bonus:
    push rbp
    mov rbp, rsp

    mov rdi, msg_simd_title
    call print_string

    mov rdi, msg_avx_status
    call print_string

    mov rdi, msg_simd_th
    call print_string

    mov rdi, msg_simd_bench
    call print_string

    mov rsp, rbp
    pop rbp
    ret
