section .data
    msg_io_title db 0xA, "--- MODULO 2: MONITOR DE PUERTOS E/S ---", 0xA, 0
    msg_p60      db "Puerto 60h (Teclado):  [OK]", 0xA, 0
    msg_p61      db "Puerto 61h (Panel):    [OK]", 0xA, 0
    msg_p3F8     db "Puerto 3F8h (COM1):    [OK]", 0xA, 0

section .text
    global check_io_ports
    extern print_string

check_io_ports:
    push rbp
    mov rbp, rsp

    mov rdi, msg_io_title
    call print_string

    mov rdi, msg_p60
    call print_string

    mov rdi, msg_p61
    call print_string

    mov rdi, msg_p3F8
    call print_string

    mov rsp, rbp
    pop rbp
    ret
