section .data
    ; System calls
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    ; File descriptors
    STDOUT equ 1
    ; Exit codes
    EXIT_NORMAL equ 0
    EXIT_ERROR equ 1
    ; Messages
    WRONG_ARGC_MSG db "Error: expected two arguments", 0xA
    WRONG_ARGC_MSG_LEN equ $ - WRONG_ARGC_MSG

section .text
    global _start

_start:
    ; Pop the number of input argments from the stact and store it in rcx
    pop rcx
    ; Expects 2 arguments
    cmp rcx, 3
    jne argcError
    mov rdi, EXIT_NORMAL

    ; Skip the first argument in argv, since it points to the name of the
    ; program
    ; Move stack pointer by one byte
    add rsp, 8

    ; Move first item in argv to rdi
    pop rdi
    call str_to_int
    ; Store str_to_int result in r8
    mov r8, rax

    ; Move second item in argv to rdi
    pop rdi
    call str_to_int
    ; Store str_to_int result in r9
    mov r9, rax

    ; Sum two inputs and store result in r8
    add r8, r9

    mov rdi, r8
    jmp print_result

; Convert str to int
; IN (rdi) OUT (rax) MOD (RBX)
; RDI is the string
str_to_int:
    ; Set rax to zero. It will store the return value.
    xor rax, rax
.repeat:
    ; Check if current byte is NULL. Operation size defined by `byte`.
    cmp [rdi], byte 0x0
    je .return
    ; Store on 
    mov bl, [rdi]
    ; Multiply by 10 to add a zero to the end of the result
    imul rax, 10
    ; Convert str to integer by subtracting 48
    sub bl, 48
    ; Add next digit to result
    add rax, rbx
    ; Move to the next byte in str
    inc rdi
    jmp .repeat
.return:
    ret

; IN (rdi)
; RDI is the integer
print_result:
    ; Move input to rax for div
    mov rax, rdi
    ; Zero out rcx as the counter for number of characters
    xor rcx, rcx
    ; Push new line character to stack
    push 0xA
    inc rcx
    ; Set divisor
    mov rbx, 10

.repeat:
    ; Set division remainder to zero. Needs to be reset each round, because
    ; rdx stores the higher parts of the number divided and rax stores the lower
    ; parts of the number. On 64 bit machine they represent a 64+64 bit number,
    ; (often notated RDX:RAX) so if you don't set the higher parts as zero, the
    ; resuling quotiont might not fit in the 64 but rax register.
    ; https://stackoverflow.com/a/38416896
    xor rdx, rdx
    ; Divide rax by rbx (10), quotient is stored in rax and remainder in rdx
    div rbx
    ; Add 48 to remainder to convert to ASCII
    add rdx, 48
    ; Store character in stack
    push rdx
    inc rcx
    ; Check if quotient is zero
    cmp rax, 0x0
    jne .repeat

.write:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    ; Set start of the string to the current stack pointer
    mov rsi, rsp
    ; Set string length according to counter
    mov rdx, rcx
    ; Multiply the number from the counter with 8 since inc only increments the
    ; counter by one byte and push pushes 8 bytes to the stack.
    imul rdx, 8
    syscall

    ; Exit code 0
    mov rdi, 0
    jmp exit


argcError:
    mov rax, SYS_WRITE
    mov rdi, STDOUT
    mov rsi, WRONG_ARGC_MSG
    mov rdx, WRONG_ARGC_MSG_LEN
    syscall
    mov rdi, EXIT_ERROR
    jmp exit

; IN (rdi)
; RDI is the exit code
exit:
    mov rax, SYS_EXIT
    syscall
