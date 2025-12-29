section .data
    ; System calls
    SYS_WRITE equ 1
    SYS_EXIT equ 60

    ; File Descriptors
    STDOUT equ 1

    ; Input data
    MSG1 db "Morjesta!"

    MSG2 db "Debuggista!"

    NEW_LINE db 10

; Pointer to argv[0] (program name)
%define argv0 qword [rsp + 8]

; Print with new line
%macro println 1
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    ; String pointer
    mov rsi, %1
    ; String lenght using the nasm builtin %strlen macro
    mov rdx, %strlen(%1)
    syscall

    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, NEW_LINE
    ; New line lenght
    mov rdx, 1
    syscall
%endmacro

; Exit with code
%macro exit 1
    mov rax, SYS_EXIT
    mov rdi, %1
    syscall
%endmacro

section .text
    global _start

_start:
    %ifndef DEBUG
        println MSG1, MSG1_LEN
    %else
        println MSG2, MSG2_LEN
    %endif
    exit 0
