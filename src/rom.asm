; ROM BIOS replacement to test x86 CPUs. Should be loaded at physical address 0xE0000

[bits 16]
[org 0xE0000]
[cpu 386]

; try to use a minimum number of instructions here, we want this to be simple enough that we can step through it manually 
_start: 
    ; Set up stack
    cli
    mov ax, 0x1000
    mov ss, ax
    mov es, ax
    mov sp, 0xFFFE

    ; Set up DS
    mov ax, 0xE000
    mov ds, ax

    jmp testbegin

; This routine is a disaster in the making.
hexchrs: db '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F'
printstr:
    ; For string operations and general calculations
    push ax
    ; For loop counters
    push cx
    ; For port I/O accesses
    push dx
    mov dx, 0x402
    ; For xlat lookup
    push bx
    mov bx, hexchrs
    ; For string index
    push si
    ; For hex string translation buffer
    push di
    xor di, di ; Bottom of stack area

    push bp
    mov bp, sp
    add bp, 18

    cld

.looptop: 
    lodsb ; Load byte from DS:SI and increment SI

    test al, al
    jz .done

    cmp al, '$'
    jnz .printchr

    ; check for number of hex characters

    ; Determine number of hex characters to print
    ; cx = (*si++ - '0') & 0xFF
    lodsb 
    sub al, '0'
    cbw
    push ax

    mov dx, [bp + 2]
    call .dx2hex
    mov dx, [bp]
    call .dx2hex

    ; cx = oldAX
    pop cx

    ; di = 8 - cx
    mov di, 8
    sub di, cx

    ; si <-> di
    xchg di, si

    mov dx, 0x402
    es rep outsb

    mov si, di

    ; Move to the next argument 
    add bp, 4

    mov dx, 0x402
    xor di, di

    ; Go back to the top of the loop
    jmp .looptop

.printchr:
    ; DX is already 0x402, and AL should contain the character to print. 
    out dx, al

    jmp .looptop

.done: 

    mov al, 10
    out dx, al

    pop bp

    pop di
    pop si
    pop bx
    pop dx
    pop cx 
    pop ax
    ret

; Inputs:
;  DX: 16-bit hex value
;  DI: Number of characters left to print
; Outputs:
;  AX: Clobbered
;  CX: Clobbered
;  DI: After this word was printed, how many characters left
; For example, passing "0x1234" in DX would make this routine output the characters '4321' and DI would be set to the memory location following the '1.'
.dx2hex_lut: db 0, 8, 6, 0, 4
.dx2hex: 
    mov cx, 4
.looptop1: 
    ; ax = (dx & 0x0F)
    rol dx, 4
    mov ax, dx
    and ax, 15
    ; ax >>= dx2hex_lut[cx]

    ; al = hexchrs[al] (note that hexchrs is currently in bx right now)
    xlat
    
    ; *di++ = al
    es stosb

    ; if (--cx) goto .top
    loop .looptop1
.ret_from_dx2hex:
    ret

testbegin:
%include "gen.asm"

    cli
    hlt

times (0x20000 - (16) - ($-$$)) db 0
call 0xE000:_start ; Jump to very beginning of test ROM

times (0x20000 - ($-$$)) db 0