; Kaudo LSP Launcher (Assembly)
; Best Practices:
; - Keep the launcher tiny; delegate to external asm-lsp via stdio.
; - Inherit stdio; do not transform I/O; minimize latency.
; - Pass through arguments if provided; default to just the binary name.
; - Allow env to select path by exporting a different binary on PATH.
; - Exit with the upstream server status when possible.

BITS 64

SECTION .data
path:       db "asm-lsp", 0

SECTION .bss
; space for argv pointers (argc <= 64 presumed sufficient for launcher)
argv_space: resq 66

SECTION .text
global _start

; On Linux, _start receives argc in RDI, argv in RSI for static PIE? Actually, SysV ABI: _start: stack layout
; We'll parse from stack to build argv vector for execve.

_start:
    ; Read argc and argv from stack
    mov rbx, rsp
    mov rdi, [rbx]              ; argc
    lea rsi, [rbx + 8]          ; argv (pointer to pointers)

    ; Build new argv: ["asm-lsp", argv[1..]] if argc>1 else ["asm-lsp"]
    lea r8, [rel argv_space]
    lea r9, [rel path]
    mov [r8], r9                ; argv[0] = path
    xor rcx, rcx                ; count of args copied

    cmp rdi, 1
    jle .only0

    ; copy argv[1..argc-1]
    mov r10, 1
.copy_loop:
    cmp r10, rdi
    jge .finish
    mov r11, [rsi + r10*8]
    mov [r8 + (r10)*8], r11
    inc r10
    inc rcx
    jmp .copy_loop

.only0:
    ; nothing more
    nop

.finish:
    ; null terminate argv
    mov rax, 0
    mov [r8 + (rdi)*8], rax

    ; execve(path, argv_new, envp=NULL => use current)
    mov rax, 59                 ; sys_execve
    lea rdi, [rel path]
    lea rsi, [rel argv_space]
    xor rdx, rdx
    syscall

    ; if execve fails, exit(1)
    mov rdi, 1
    mov rax, 60                 ; sys_exit
    syscall
