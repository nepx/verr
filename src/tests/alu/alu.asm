%define TESTCASES (8 * 4)

%macro getflags 1
    pushfw
    pop word %1
%endmacro

; Test various operand forms

; Save DS
push ds

; DS = ES (we want the DS segment to have writable data)
push es
pop ds

%macro EbGb 2
mov byte [0], 0x55
mov ch, 0xAA
clc
%1 byte [0], ch
cmp byte [0], %2
jnz fail
inc dx
%endmacro

%macro GbEb 2
mov ch, 0x55
mov byte [0], 0xAA
clc
%1 ch, byte [0]
cmp ch, %2
jnz fail
inc dx
%endmacro

%macro EbGbR 2
mov bl, 0xAA ; src
mov dh, 0x55 ; dest
clc
; opcode (alu reg, r/m)
db %1
; ModR/M
;  mod=3 (reg-reg)
;  reg=3 (bl - src)
;  r/m=6 (dh - dest)
db 0xDE
cmp dh, %2
jnz fail
inc dx
%endmacro

%macro GbEbR 2
mov bl, 0x55 ; dest
mov dh, 0xAA ; src
clc
; opcode (alu reg, r/m)
db %1 | 0x02
; ModR/M
;  mod=3 (reg-reg)
;  reg=3 (bl - dest)
;  r/m=6 (dh - src)
db 0xDE
cmp bl, %2
jnz fail
inc dx
%endmacro

; word tests
%macro EwGw 2
mov word [0], 0x5555
mov cx, 0xAAAA
clc
%1 word [0], cx
cmp word [0], %2
jnz fail
inc dx
%endmacro

%macro GwEw 2
mov cx, 0x5555
mov word [0], 0xAAAA
clc
%1 cx, word [0]
cmp cx, %2
jnz fail
inc dx
%endmacro

%macro EwGwR 2
mov bx, 0xAAAA ; src
mov si, 0x5555 ; dest
clc
; opcode (alu reg, r/m)
db %1 | 0x01
; ModR/M
;  mod=3 (reg-reg)
;  reg=3 (bx - src)
;  r/m=6 (si - dest)
db 0xDE
cmp si, %2
jnz fail
inc dx
%endmacro

%macro GwEwR 2
mov bx, 0x5555
mov si, 0xAAAA
clc
; opcode (alu reg, r/m)
db %1 | 0x03
; ModR/M
;  mod=3 (reg-reg)
;  reg=3 (bx - dest)
;  r/m=6 (si - src)
db 0xDE
cmp bx, %2
jnz fail
inc dx
%endmacro

; dword tests
%macro EdGd 2
mov dword [0], 0x55555555
mov ecx, 0xAAAAAAAA
clc
%1 dword [0], ecx
cmp dword [0], %2
jnz fail
inc dx
%endmacro

%macro GdEd 2
mov ecx, 0x55555555
mov dword [0], 0xAAAAAAAA
clc
%1 ecx, dword [0]
cmp ecx, %2
jnz fail
inc dx
%endmacro

%macro EdGdR 2
mov ebx, 0xAAAAAAAA ; src
mov esi, 0x55555555 ; dest
clc
; prefix
db 0x66
; opcode (alu reg, r/m)
db %1 | 0x01
; ModR/M
;  mod=3 (reg-reg)
;  reg=3 (bx - src)
;  r/m=6 (si - dest)
db 0xDE
cmp esi, %2
jnz fail
inc dx
%endmacro

%macro GdEdR 2
mov ebx, 0x55555555
mov esi, 0xAAAAAAAA
clc
; prefix
db 0x66
; opcode (alu reg, r/m)
db %1 | 0x03
; ModR/M
;  mod=3 (reg-reg)
;  reg=3 (bx - dest)
;  r/m=6 (si - src)
db 0xDE
cmp ebx, %2
jnz fail
inc dx
%endmacro

; +4/+5
%macro ALIb 2
mov al, 0x55
; A smart assembler (i.e. nasm) should assemble this using the one-byte +4 opcode
%1 al, 0xAA
cmp al, %2
jnz fail
inc dx
%endmacro

%macro AXIw 2
mov ax, 0x5555
%1 ax, 0xAAAA
cmp ax, %2
jnz fail
inc dx
%endmacro

%macro EAXId 2
mov eax, 0x55555555
%1 eax, 0xAAAAAAAA
cmp eax, %2
jnz fail
inc dx
%endmacro

xor dx, dx ; test counter
AddRes8 equ (0x55+0xAA)&0xFF
AddRes16 equ (0x5555+0xAAAA)&0xFFFF
AddRes32 equ (0x55555555+0xAAAAAAAA)&0xFFFFFFFF
; +0/+2
EbGb add,AddRes8 ; 0
GbEb add,AddRes8 ; 1
EbGbR 0x00,AddRes8 ; 2
GbEbR 0x00,AddRes8 ; 3
; +1/+3
EwGw add,AddRes16 ; 4
GwEw add,AddRes16 ; 5
EdGd add,AddRes32 ; 6
GdEd add,AddRes32 ; 7
EwGwR 0x00,AddRes16 ; 8
GwEwR 0x00,AddRes16 ; 9
EdGdR 0x00,AddRes32 ; A
GdEdR 0x00,AddRes32 ; B
; +4/+5
ALIb add,AddRes8 ; C
AXIw add,AddRes16 ; D
EAXId add,AddRes32 ; E
inc dx ; F (never fail)

OrRes8 equ (0x55|0xAA)&0xFF
OrRes16 equ (0x5555|0xAAAA)&0xFFFF
OrRes32 equ (0x55555555|0xAAAAAAAA)&0xFFFFFFFF
; +0/+2
EbGb or,OrRes8 ; 0x10
GbEb or,OrRes8 ; 0x11
EbGbR 0x08,OrRes8 ; 0x12
GbEbR 0x08,OrRes8 ; 0x13
; +1/+3
EwGw or,OrRes16 ; 0x14
GwEw or,OrRes16 ; 0x15
EdGd or,OrRes32 ; 0x16
GdEd or,OrRes32 ; 0x17
EwGwR 0x08,OrRes16 ; 0x18
GwEwR 0x08,OrRes16 ; 0x19
EdGdR 0x08,OrRes32 ; 0x1A
GdEdR 0x08,OrRes32 ; 0x1B
; +4/+5
ALIb or,OrRes8 ; 0x1C
AXIw or,OrRes16 ; 0x1D
EAXId or,OrRes32 ; 0x1E
inc dx ; 0x1F (never fail)

; +0/+2
EbGb adc,AddRes8 ; 0x20
GbEb adc,AddRes8 ; 0x21
EbGbR 0x10,AddRes8 ; 0x22
GbEbR 0x10,AddRes8 ; 0x23
; +1/+3
EwGw adc,AddRes16 ; 0x24
GwEw adc,AddRes16 ; 0x25
EdGd adc,AddRes32 ; 0x26
GdEd adc,AddRes32 ; 0x27
EwGwR 0x10,AddRes16 ; 0x28
GwEwR 0x10,AddRes16 ; 0x29
EdGdR 0x10,AddRes32 ; 0x2A
GdEdR 0x10,AddRes32 ; 0x2B
; +4/+5
ALIb adc,AddRes8 ; 0x2C
AXIw adc,AddRes16 ; 0x2D
EAXId adc,AddRes32 ; 0x2E
inc dx ; 0x2F (never fail)

SubRes8 equ (0x55-0xAA)&0xFF
SubRes16 equ (0x5555-0xAAAA)&0xFFFF
SubRes32 equ (0x55555555-0xAAAAAAAA)&0xFFFFFFFF
EbGb sbb,SubRes8 ; 0x30
GbEb sbb,SubRes8 ; 0x31
EbGbR 0x18,SubRes8 ; 0x32
GbEbR 0x18,SubRes8 ; 0x33
; +1/+3
EwGw sbb,SubRes16 ; 0x34
GwEw sbb,SubRes16 ; 0x35
EdGd sbb,SubRes32 ; 0x36
GdEd sbb,SubRes32 ; 0x37
EwGwR 0x18,SubRes16 ; 0x38
GwEwR 0x18,SubRes16 ; 0x39
EdGdR 0x18,SubRes32 ; 0x3A
GdEdR 0x18,SubRes32 ; 0x3B
; +4/+5
ALIb sbb,SubRes8 ; 0x3C
AXIw sbb,SubRes16 ; 0x3D
EAXId sbb,SubRes32 ; 0x3E
inc dx ; 0x3F (never fail)

AndRes8 equ (0x55&0xAA)&0xFF
AndRes16 equ (0x5555&0xAAAA)&0xFFFF
AndRes32 equ (0x55555555&0xAAAAAAAA)&0xFFFFFFFF
; +0/+2
EbGb and,AndRes8 ; 0x40
GbEb and,AndRes8 ; 0x41
EbGbR 0x20,AndRes8 ; 0x42
GbEbR 0x20,AndRes8 ; 0x43
; +1/+3
EwGw and,AndRes16 ; 0x44
GwEw and,AndRes16 ; 0x45
EdGd and,AndRes32 ; 0x46
GdEd and,AndRes32 ; 0x47
EwGwR 0x20,AndRes16 ; 0x48
GwEwR 0x20,AndRes16 ; 0x49
EdGdR 0x20,AndRes32 ; 0x4A
GdEdR 0x20,AndRes32 ; 0x4B
; +4/+5
ALIb and,AndRes8 ; 0x4C
AXIw and,AndRes16 ; 0x4D
EAXId and,AndRes32 ; 0x4E
inc dx ; 0x4F (never fail)

EbGb sub,SubRes8 ; 0x50
GbEb sub,SubRes8 ; 0x51
EbGbR 0x28,SubRes8 ; 0x52
GbEbR 0x28,SubRes8 ; 0x53
; +1/+3
EwGw sub,SubRes16 ; 0x54
GwEw sub,SubRes16 ; 0x55
EdGd sub,SubRes32 ; 0x56
GdEd sub,SubRes32 ; 0x57
EwGwR 0x28,SubRes16 ; 0x58
GwEwR 0x28,SubRes16 ; 0x59
EdGdR 0x28,SubRes32 ; 0x5A
GdEdR 0x28,SubRes32 ; 0x5B
; +4/+5
ALIb sub,SubRes8 ; 0x5C
AXIw sub,SubRes16 ; 0x5D
EAXId sub,SubRes32 ; 0x5E
inc dx ; 0x5F (never fail)

XorRes8 equ (0x55^0xAA)&0xFF
XorRes16 equ (0x5555^0xAAAA)&0xFFFF
XorRes32 equ (0x55555555^0xAAAAAAAA)&0xFFFFFFFF
; +0/+2
EbGb xor,XorRes8 ; 0x60
GbEb xor,XorRes8 ; 0x61
EbGbR 0x30,XorRes8 ; 0x62
GbEbR 0x30,XorRes8 ; 0x63
; +1/+3
EwGw xor,XorRes16 ; 0x64
GwEw xor,XorRes16 ; 0x65
EdGd xor,XorRes32 ; 0x66
GdEd xor,XorRes32 ; 0x67
EwGwR 0x30,XorRes16 ; 0x68
GwEwR 0x30,XorRes16 ; 0x69
EdGdR 0x30,XorRes32 ; 0x6A
GdEdR 0x30,XorRes32 ; 0x6B
; +4/+5
ALIb xor,XorRes8 ; 0x6C
AXIw xor,XorRes16 ; 0x6D
EAXId xor,XorRes32 ; 0x6E
inc dx ; 0x6F (never fail)

CmpRes8 equ 0x55
CmpRes16 equ 0x5555
CmpRes32 equ 0x55555555
; +0/+2
EbGb cmp,CmpRes8 ; 0x70
GbEb cmp,CmpRes8 ; 0x71
EbGbR 0x38,CmpRes8 ; 0x72
GbEbR 0x38,CmpRes8 ; 0x73
; +1/+3
EwGw cmp,CmpRes16 ; 0x74
GwEw cmp,CmpRes16 ; 0x75
EdGd cmp,CmpRes32 ; 0x76
GdEd cmp,CmpRes32 ; 0x77
EwGwR 0x38,CmpRes16 ; 0x78
GwEwR 0x38,CmpRes16 ; 0x79
EdGdR 0x38,CmpRes32 ; 0x7A
GdEdR 0x38,CmpRes32 ; 0x7B
; +4/+5
ALIb cmp,CmpRes8 ; 0x7C
AXIw cmp,CmpRes16 ; 0x7D
EAXId cmp,CmpRes32 ; 0x7E
inc dx ; 0x7F (never fail)

; 80-83 tests
%macro EbIb 2
mov byte [0], 0x55
%1 byte [0], 0xAA
cmp byte [0], %2
jnz fail
inc dx
%endmacro

%macro EbIbR 2
mov ah, 0x55
; opcode
db 0x80
; ModR/M: c4 
db 0xC4 | (%1 shl 3)
cmp byte [0], %2
jnz fail
inc dx
%endmacro

%macro EwIw 2
mov word [0], 0x5555
%1 word [0], 0xAAAA
cmp word [0], %2
jnz fail
inc dx
%endmacro
%macro EdId 2
mov dword [0], 0x55555555
%1 dword [0], 0xAAAAAAAA
cmp dword [0], %2
jnz fail
inc dx
%endmacro

pop ds

jmp begintest

failstr: db 'alu 0x$2 failed', 0
fail: 
    ; We failed the basic opcode tests
    pop ds
    mov si, failstr
    push dx
    push word 0
    call printstr
    cli
    hlt

; Print, no carry tested. Format string should be in vsi
print_nc8_16: 
    push dx ; flags
    push word 0
    push ax ; res
    push word 0
    push cx ; op2
    push word 0
    push bx ; op1
    push word 0
    call printstr
    add sp, 4 * 4
    ret

print_c8_16: 
    push dx ; flags
    push word 0
    push ax ; res
    push word 0
    push cx ; op2
    push word 0
    push bx ; op1
    push bp ; cf
    push word 0
    call printstr
    add sp, 5 * 4
    ret

begintest: 

; Here are the tests that check for result 
%define vax al 
%define vcx cl 
%define vbx bl

%define print_c print_c8_16
%define print_nc print_nc8_16

%define TESTCASE_TBL_OP1 testcase8_op1
%define TESTCASE_TBL_OP2 testcase8_op2

%define TESTID add8
%define TESTSTR "add8 $2+$2=$2 fl=$4"
%define TESTINSN add
%include "testalu.asm"

%define TESTID or8
%define TESTSTR "or8 $2|$2=$2 fl=$4"
%define TESTINSN or
%include "testalu.asm"

%define CARRY_TEST
%define TESTID adc8
%define TESTSTR "adc8 $1+$2+$2=$2 fl=$4"
%define TESTINSN adc
%include "testalu.asm"

%define TESTID sbb8
%define TESTSTR "sbb8 -$1+$2-$2=$2 fl=$4"
%define TESTINSN sbb
%include "testalu.asm"

cli
hlt

testcase8_op1:
    dd 0x12 ; should check SZP
    dd -0x12
    dd 0x7F ; OF test
    dd 0x80
    dd 0xFF ; CF test
    dd 0x00
    dd 0x0F ; AF test
    dd 0x10

testcase8_op2: 
    dd 0x34
    dd -0x34
    dd 0
    dd 1
    dd 2
    dd -1
    dd -2
    dd 0x55 ; shift-mask test, odd

testcase16_op1:
    dd 0x1234 ; should check SZP
    dd -0x1234
    dd 0x7FFF ; OF test
    dd 0x8000
    dd 0xFFFF ; CF test
    dd 0x0000
    dd 0x000F ; AF test
    dd 0x0010

testcase16_op2: 
    dd 0x5678
    dd -0x5678
    dd 0
    dd 1
    dd 2
    dd -1
    dd -2
    dd 0x55AA ; shift-mask test, odd

testcase32_op1:
    dd 0x12345678 ; should check SZP
    dd -0x12345678
    dd 0x7FFFFFFF ; OF test
    dd 0x80000000
    dd 0xFFFFFFFF ; CF test
    dd 0x00000000
    dd 0x0000000F ; AF test
    dd 0x00000010

testcase32_op2: 
    dd 0x9ABCDEF0
    dd (-0x9ABCDEF0) & 0xFFFFFFFF
    dd 0
    dd 1
    dd 2
    dd -1
    dd -2
    dd 0x55AA55AA ; shift-mask test, odd