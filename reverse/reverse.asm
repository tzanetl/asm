section .data
    ; Syscalls
    SYS_WRITE equ 1
    SYS_EXIT equ 60

    ; File descriptors
    STDOUT equ 1

    ; Input
    INPUT db "Morjesta!"
    INPUT_LEN equ $ - INPUT

    NEW_LINE db 0xA

section .bss
    ; Reserve output string buffer
    OUTPUT resb INPUT_LEN

section .text
    global _start

_start:
    ; Input and output buffers
    mov rcx, INPUT
    mov rsi, OUTPUT
    ; Move input buffer pointer to the last char in the string by adding the lenght of the string to
    ; the pointer minus one
    add rcx, INPUT_LEN
    dec rcx

.repeat:
    ; Copy byte value from input buffer address
    mov bl, byte [rcx]
    ; Move the copied byte value to output buffer address
    mov [rsi], bl
    ; If the input buffers points to the start of that buffer, all chars have been added to output
    cmp rcx, INPUT
    je .write

    ; Move input buffer pointer backwards
    dec rcx
    ; Move output buffer forwards
    inc rsi
    ; Repeat
    jmp .repeat

.write:
    ; Write reversed string to output buffer
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, OUTPUT
    mov rdx, INPUT_LEN
    syscall

    ; Write new line
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, NEW_LINE
    mov rdx, 1
    syscall

.exit:
    mov rax, SYS_EXIT
    ; Exit code
    mov rdi, 0
    syscall
