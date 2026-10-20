section .data
    msg_hier_title db 0xA, "--- MODULO 5: GESTION JERARQUICA DE MEMORIA ---", 0xA, 0
    msg_reg        db "Registros:       1 ciclo", 0xA, 0
    msg_l1         db "L1 cache:        4 ciclos    (32KB)", 0xA, 0
    msg_l2         db "L2 cache:        12 ciclos   (256KB)", 0xA, 0
    msg_l3         db "L3 cache:        30 ciclos   (8MB)", 0xA, 0
    msg_ram        db "RAM principal:   105 ciclos  (32GB)", 0xA, 0

section .text
    global measure_mem_hierarchy
    extern print_string

measure_mem_hierarchy:
    push rbp
    mov rbp, rsp

    mov rdi, msg_hier_title
    call print_string

    mov rdi, msg_reg
    call print_string

    mov rdi, msg_l1
    call print_string

    mov rdi, msg_l2
    call print_string

    mov rdi, msg_l3
    call print_string

    mov rdi, msg_ram
    call print_string

    mov rsp, rbp
    pop rbp
    ret
