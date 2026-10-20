section .data
    header db "==========================================", 0xA
           db "  LowMonitor v1.0 - Diagnostico Hardware  ", 0xA
           db "==========================================", 0xA, 0

section .text
    global _start
    global print_string
    extern print_cpu_info
    extern check_io_ports
    extern run_mem_diag
    extern measure_cpu_perf
    extern measure_mem_hierarchy
    extern run_simd_bonus

_start:
    mov rdi, header
    call print_string

    call print_cpu_info
    call check_io_ports
    call run_mem_diag
    call measure_cpu_perf
    call measure_mem_hierarchy
    call run_simd_bonus

    mov rax, 60
    xor rdi, rdi
    syscall

print_string:
    push rbx
    mov rbx, rdi
    xor rdx, rdx
.len_loop:
    cmp byte [rbx + rdx], 0
    je .print
    inc rdx
    jmp .len_loop
.print:
    cmp rdx, 0
    je .done
    mov rax, 1
    mov rsi, rbx
    mov rdi, 1
    syscall
.done:
    pop rbx
    ret
