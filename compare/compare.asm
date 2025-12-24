section .data
    ; First and second number
    num1 dq 0x64
    num2 dq 0x32
    ; Message for true statement, 10 is line feed in ASCII
    msgtrue db "Sum is correct!", 10
    msgtruelen equ $ - msgtrue

section .text
    global _start

_start:
    mov rax, [num1]
    mov rbx, [num2]
    ; Sum of rax and rbx, result stored in rax
    add rax, rbx

.compare:
    ; Check is sum equals to 150
    cmp rax, 150
    ; Go to .exit if it does not match
    jne .exit
    ; Go to .correct if matches
    jmp .correct

; Print message to std out
.correct:
    ; sys_write
    mov rax, 1
    ; stdout
    mov rdi, 1
    ; Message content
    mov rsi, msgtrue
    ; Message size
    mov rdx, msgtruelen
    syscall
    ; Go to .exit
    jmp .exit

.exit:
    ; sys_exit
    mov rax, 60
    ; Status code
    mov rdi, 0
    syscall
