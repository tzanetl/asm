section .data
    ; 0xA is line feed (LF)
    msg db "Morjesta!", 0xA
    msgsize equ $ - msg

section .text
    global _start

_start:
    ; sys_write
    mov rax, 1
    ; sys_write arg1 (stdout)
    mov rdi, 1
    ; sys_write arg2 (reference to str)
    mov rsi, msg
    ; sys_write arg3 (arg2 length)
    mov rdx, msgsize
    syscall

    ; sys_exit
    mov rax, 60
    ; sys_exit arg1 (exit code)
    mov rdi, 0
    syscall
