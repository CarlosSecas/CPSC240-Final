; Name: Carlos Secas
; CWID: 886088269
; Class: 240-09 Section 09
; Email: carlosJsecas@gmail.com
; Today's date : 4/23/2025
; Final Program

global analyzer
extern printf
extern scanf

segment .data

    prompt_msg1 db "Please enter 4 quadword integers seperated by ws. These will be pushed on the stack.", 10, 0
    thank_you_msg1 db "Thank you.  These inputs have been pushed on the stack.", 10, 0
    ar_properties_msg db "Here are properties of the current AR.", 10, 0
    backend_msg db "The backend is located at %p and contains 0x%016lX", 10, 0
    frontend_msg db "The frontend is located at  %p and contains 0x%016lX", 10, 0
    ar_count_msg db "The number of qwords in the current AR is %d", 10, 0
    ar_listing_msg db "Here is a listing of the current AR:", 10, 0
    enter_more_msg db 10, "Please enter 2 additional long integers,  These will be pushed on the stack.", 10, 0
    thank_you_msg2 db "Thank you.  Here is an updated listing of the current AR", 10, 0
    return_msg db 10, "The contents of the top of stack will be returned to the main function.", 10, 0

    fmt_hex_line db "0x%016lX", 10, 0
    fmt_scan db "%ld", 0

segment .bss
    input_buf resq 6


segment .text
analyzer:
    push rbp
    mov rbp, rsp

    ; Prompt user
    mov rdi, prompt_msg1
    call printf

    mov r12, input_buf

    xor r13, r13     ; counter (0–3)

.read_loop:

    mov rdi, fmt_scan
    mov rsi, r13
    shl rsi, 3            ; multiply index by 8
    add rsi, r12          ; rsi = base + offset
    xor rax, rax         ; REQUIRED before scanf (variadic)
    call scanf


    inc r13
    cmp r13, 4
    jl .read_loop

    ; After this loop completes, insert push loop below:
    xor r14, r14

    .push_loop:
    mov rax, [r12 + r14*8]
    push rax
    inc r14
    cmp r14, 4
    jl .push_loop


 ;Begin AR Display
    mov rdi, thank_you_msg1
    call printf

    mov rdi, ar_properties_msg
    call printf

  ;Backend info

    mov rdi, backend_msg     ; "The backend is located at %p and contains 0x%016lX"
    mov rsi, rsp
    add rsi, 24
    mov rax, [rsi]          ; value at backend
    mov rdx, rax
    xor rax, rax
    call printf

;Frontend info
    mov rdi, frontend_msg    ; "The frontend is located at %p and contains 0x%016lX"
    mov rsi, rsp             ; pointer
    mov rax, [rsp]           ; value at frontend
    mov rdx, rax
    xor rax, rax
    call printf

 ;Print number of qwords in AR
    mov rax, rbp
    sub rax, rsp         ; (rbp - rsp)
    shr rax, 3           ; divide by 8 (qwords)
    mov rsi, rax
    mov rdi, ar_count_msg
    xor rax, rax
    call printf

    ; r15 = scan pointer from rbp down to rsp
    mov r15, rbp
    sub r15, 8

.print_loop:
    cmp r15, rsp
    jb .done_printing    ; stop if r15 < rsp (we've hit the stack bottom)

    mov rsi, [r15]       ; load 8 bytes at current location
    mov rdi, fmt_hex_line
    xor rax, rax
    call printf

    sub r15, 8           ; move to next lower qword
    jmp .print_loop

.done_printing:

;Prompt for 2 more values
    mov rdi, enter_more_msg
    call printf

    xor r13, r13      ; reuse counter

.read_more:
    mov rdi, fmt_scan
    mov rsi, r13
    shl rsi, 3
    add rsi, input_buf
    add rsi, 32
    xor rax, rax
    call scanf
    inc r13
    cmp r13, 2
    jl .read_more


    ;Push those 2 values onto the stack
    xor r14, r14

.push_more:
    mov rax, [input_buf + r14*8 + 32]
    push rax
    inc r14
    cmp r14, 2
    jl .push_more

    ;Print updated AR message
    mov rdi, thank_you_msg2
    call printf

    mov r15, rbp
    sub r15, 8     ; skip saved rbp

.print_updated:
    cmp r15, rsp
    jb .done_updated

    mov rsi, [r15]
    mov rdi, fmt_hex_line
    xor rax, rax
    call printf

    sub r15, 8
    jmp .print_updated

.done_updated:

    mov rax, [rsp]
    add rsp, 48
    pop rbp
    ret