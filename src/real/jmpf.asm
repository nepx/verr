; JMPF: Tests opcode EA and FF /5
; 
; Failure codes: 
;  - 1: 16-bit EA failed 
;  - 2: 32-bit EA failed
;  - 3: 16-bit indirect EA failed
;  - 4: 32-bit indirect EA failed

[bits 16]
[org 0]

_start: 
    inc al ; al = 1
    jmp far 0xfff:test32+16 ; going back one segment involves pushing everything forward by 16 bytes
    jmp fail

test32: 
    inc al ; al = 2

    ; Test 32-bit far jumps. In real mode, the upper 32 bits should be ignored
    db 0x66
    db 0xEA
    dw 0x1234 ; Upper order word can contain garbage
    dw test_indirect + 32 ; Bottom order word points to next test + 32 since we move two steps back
    dw 0xffe
    jmp fail

test_indirect:
    inc al ; al = 3

    ; Tests 16-bit indirect far jumps
    mov cx, 0x1000
    mov ds, cx

    ; DS points to this segment, CS points to something wildly different
    jmp far [.data] ; should pull from ds
    jmp fail
.data:
    dw test_indirect32 + 48
    dw 0xffd

test_indirect32:
    inc al ; al = 4
    ; Tests 32-bit indirect far jumps
    jmp far [.data]

.data: 
    dw 0x1234 ; garbage
    dw success + 64 ; adjusted ip
    dw 0xffc ; cs

success: 
    mov dx, 0x1234
    xor al, al
    out dx, al
    hlt

fail: 
    mov dx, 0x1234
    out dx, al
    hlt