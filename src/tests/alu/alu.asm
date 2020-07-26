%define TESTCASES (8 * 4)

%macro getflags 1
    pushfw
    pop word %1
%endmacro

; Test various operand forms

_alustart: 
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
jnz .fail
inc di
%endmacro

%macro GbEb 2
mov ch, 0x55
mov byte [0], 0xAA
clc
%1 ch, byte [0]
cmp ch, %2
jnz .fail
inc di
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
jnz .fail
inc di
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
jnz .fail
inc di
%endmacro

; word tests
%macro EwGw 2
mov word [0], 0x5555
mov cx, 0xAAAA
clc
%1 word [0], cx
cmp word [0], %2
jnz .fail
inc di
%endmacro

%macro GwEw 2
mov cx, 0x5555
mov word [0], 0xAAAA
clc
%1 cx, word [0]
cmp cx, %2
jnz .fail
inc di
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
jnz .fail
inc di
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
jnz .fail
inc di
%endmacro

; dword tests
%macro EdGd 2
mov dword [0], 0x55555555
mov ecx, 0xAAAAAAAA
clc
%1 dword [0], ecx
cmp dword [0], %2
jnz .fail
inc di
%endmacro

%macro GdEd 2
mov ecx, 0x55555555
mov dword [0], 0xAAAAAAAA
clc
%1 ecx, dword [0]
cmp ecx, %2
jnz .fail
inc di
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
jnz .fail
inc di
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
jnz .fail
inc di
%endmacro

; +4/+5
%macro ALIb 2
mov al, 0x55
; A smart assembler (i.e. nasm) should assemble this using the one-byte +4 opcode
%1 al, 0xAA
cmp al, %2
jnz .fail
inc di
%endmacro

%macro AXIw 2
mov ax, 0x5555
%1 ax, 0xAAAA
cmp ax, %2
jnz .fail
inc di
%endmacro

%macro EAXId 2
mov eax, 0x55555555
%1 eax, 0xAAAAAAAA
cmp eax, %2
jnz .fail
inc di
%endmacro

xor di, di ; test counter
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
inc di ; F (never fail)

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
inc di ; 0x1F (never fail)

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
inc di ; 0x2F (never fail)

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
inc di ; 0x3F (never fail)

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
inc di ; 0x4F (never fail)

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
inc di ; 0x5F (never fail)

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
inc di ; 0x6F (never fail)

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
inc di ; 0x7F (never fail)

; 80-83 tests
%macro EbIb 2
mov byte [0], 0x55
clc
%1 byte [0], 0xAA
cmp byte [0], %2
jnz .fail
inc di
%endmacro

%macro EbIb2 2
mov byte [0], 0x55
clc
; opcode
db 0x80
; modrm
db 0x06 | %1
; displacement
dw 0x0000
; immediate
db 0xAA
cmp byte [0], %2
jnz .fail
inc di
%endmacro

%macro EbIbR 2
mov bl, 0x55
clc
; opcode -- 0x80
db 0x80
; ModR/M: c4 
;  mod: 3 (ah)
;  r/m: 3 (bl)
;  reg: (user-specified)
db 0xC3 | %1
; Immediate
db 0xAA
cmp bl, %2
jnz .fail
inc di
%endmacro

%macro EbIbR2 2
mov bl, 0x55
clc
; opcode -- 0x82 (it's an alias of 0x80)
db 0x82
; ModR/M: c4 
;  mod: 3 (ah)
;  r/m: 3 (bl)
;  reg: (user-specified)
db 0xC3 | %1
; Immediate
db 0xAA
cmp bl, %2
jnz .fail
inc di
%endmacro

%macro EwIw 2
mov word [0], 0x5555
clc
%1 word [0], 0xAAAA
cmp word [0], %2
jnz .fail
inc di
%endmacro

%macro EwIwR 2
mov bx, 0x5555
clc
; opcode
db 0x81
; ModR/M: c4 
;  mod: 3 (ah)
;  r/m: 3 (bl)
;  reg: (user-specified)
db 0xC3 | %1
; Immediate
dw 0xAAAA
cmp bx, %2
jnz .fail
inc di
%endmacro

%macro EwIb 2
mov word [0], 0x5555
clc
%1 word [0], 0xFFAA
cmp word [0], %2
jnz .fail
inc di
%endmacro

%macro EwIbR 2
mov bx, 0x5555
clc
; opcode
db 0x83
; ModR/M: c4 
;  mod: 3 (ah)
;  r/m: 3 (bl)
;  reg: (user-specified)
db 0xC3 | %1
; Immediate (sign-extended to 0xFFAA)
db 0xAA
cmp bx, %2
jnz .fail
inc di
%endmacro

%macro EdId 2
mov dword [0], 0x55555555
clc
%1 dword [0], 0xAAAAAAAA
cmp dword [0], %2
jnz .fail
inc di
%endmacro

%macro EdIb 2
mov dword [0], 0x55555555
clc
%1 dword [0], 0xFFFFFFAA
cmp dword [0], %2
jnz .fail
inc di
%endmacro

%macro EdIdR 2
mov ebx, 0x55555555
clc
; prefix
db 0x66
; opcode
db 0x81
; ModR/M: c4 
;  mod: 3 (ah)
;  r/m: 3 (bl)
;  reg: (user-specified)
db 0xC3 | %1
; Immediate
dd 0xAAAAAAAA
cmp ebx, %2
jnz .fail
inc di
%endmacro

%macro EdIb 2
mov dword [0], 0x55555555
clc
%1 dword [0], 0xFFFFFFAA
cmp dword [0], %2
jnz .fail
inc di
%endmacro

%macro EdIbR 2
mov ebx, 0x55555555
clc
; prefix
db 0x66
; opcode
db 0x83
; ModR/M: c4 
;  mod: 3 (ah)
;  r/m: 3 (bl)
;  reg: (user-specified)
db 0xC3 | %1
; Immediate (sign-extended to 0xFFFFFFAA)
db 0xAA
cmp ebx, %2
jnz .fail
inc di
%endmacro

AddRes16_2 equ (0x5555+0xFFAA)&0xFFFF
AddRes32_2 equ (0x55555555+0xFFFFFFAA)&0xFFFFFFFF
EbIb add,AddRes8 ; 0x80
EbIbR 0x00,AddRes8 ; 0x81
EbIb2 0x00,AddRes8 ; 0x82
EbIbR2 0x00,AddRes8 ; 0x83
EwIw add,AddRes16 ; 0x84
EwIwR 0x00,AddRes16 ; 0x85
EwIb add,AddRes16_2 ; 0x86
EwIbR 0x00,AddRes16_2 ; 0x87
EdId add,AddRes32 ; 0x88
EdIdR 0x00,AddRes32 ; 0x89
EdIb add,AddRes32_2 ; 0x8A
EdIbR 0x00,AddRes32_2 ; 0x8B

add di, 4 ; Skip 0x8C to 0x8F

OrRes16_2 equ (0x5555|0xFFAA)&0xFFFF
OrRes32_2 equ (0x55555555|0xFFFFFFAA)&0xFFFFFFFF
EbIb or,OrRes8 ; 0x90
EbIbR 0x08,OrRes8 ; 0x91
EbIb2 0x08,OrRes8 ; 0x92
EbIbR2 0x08,OrRes8 ; 0x93
EwIw or,OrRes16 ; 0x94
EwIwR 0x08,OrRes16 ; 0x95
EwIb or,OrRes16_2 ; 0x96
EwIbR 0x08,OrRes16_2 ; 0x97
EdId or,OrRes32 ; 0x98
EdIdR 0x08,OrRes32 ; 0x99
EdIb or,OrRes32_2 ; 0x9A
EdIbR 0x08,OrRes32_2 ; 0x9B

add di, 4 ; Skip 0x9C to 0x9F

EbIb adc,AddRes8 ; 0xA0
EbIbR 0x10,AddRes8 ; 0xA1
EbIb2 0x10,AddRes8 ; 0xA2
EbIbR2 0x10,AddRes8 ; 0xA3
EwIw adc,AddRes16 ; 0xA4
EwIwR 0x10,AddRes16 ; 0xA5
EwIb adc,AddRes16_2 ; 0xA6
EwIbR 0x10,AddRes16_2 ; 0xA7
EdId adc,AddRes32 ; 0xA8
EdIdR 0x10,AddRes32 ; 0xA9
EdIb adc,AddRes32_2 ; 0xAA
EdIbR 0x10,AddRes32_2 ; 0xAB

add di, 4 ; Skip 0xAC to 0xAF

SubRes16_2 equ (0x5555-0xFFAA)&0xFFFF
SubRes32_2 equ (0x55555555-0xFFFFFFAA)&0xFFFFFFFF
EbIb sbb,SubRes8 ; 0xB0
EbIbR 0x18,SubRes8 ; 0xB1
EbIb2 0x18,SubRes8 ; 0xB2
EbIbR2 0x18,SubRes8 ; 0xB3
EwIw sbb,SubRes16 ; 0xB4
EwIwR 0x18,SubRes16 ; 0xB5
EwIb sbb,SubRes16_2 ; 0xB6
EwIbR 0x18,SubRes16_2 ; 0xB7
EdId sbb,SubRes32 ; 0xB8
EdIdR 0x18,SubRes32 ; 0xB9
EdIb sbb,SubRes32_2 ; 0xBA
EdIbR 0x18,SubRes32_2 ; 0xBB

add di, 4 ; Skip 0xBC to 0xBF

AndRes16_2 equ (0x5555&0xFFAA)&0xFFFF
AndRes32_2 equ (0x55555555&0xFFFFFFAA)&0xFFFFFFFF
EbIb and,AndRes8 ; 0xC0
EbIbR 0x20,AndRes8 ; 0xC1
EbIb2 0x20,AndRes8 ; 0xC2
EbIbR2 0x20,AndRes8 ; 0xC3
EwIw and,AndRes16 ; 0xC4
EwIwR 0x20,AndRes16 ; 0xC5
EwIb and,AndRes16_2 ; 0xC6
EwIbR 0x20,AndRes16_2 ; 0xC7
EdId and,AndRes32 ; 0xC8
EdIdR 0x20,AndRes32 ; 0xC9
EdIb and,AndRes32_2 ; 0xCA
EdIbR 0x20,AndRes32_2 ; 0xCB

add di, 4 ; Skip 0xCC to 0xCF

EbIb sub,SubRes8 ; 0xD0
EbIbR 0x28,SubRes8 ; 0xD1
EbIb2 0x28,SubRes8 ; 0xD2
EbIbR2 0x28,SubRes8 ; 0xD3
EwIw sub,SubRes16 ; 0xD4
EwIwR 0x28,SubRes16 ; 0xD5
EwIb sub,SubRes16_2 ; 0xD6
EwIbR 0x28,SubRes16_2 ; 0xD7
EdId sub,SubRes32 ; 0xD8
EdIdR 0x28,SubRes32 ; 0xD9
EdIb sub,SubRes32_2 ; 0xDA
EdIbR 0x28,SubRes32_2 ; 0xDB

add di, 4 ; Skip 0xDC to 0xDF

XorRes16_2 equ (0x5555^0xFFAA)&0xFFFF
XorRes32_2 equ (0x55555555^0xFFFFFFAA)&0xFFFFFFFF

EbIb xor,XorRes8 ; 0xE0
EbIbR 0x30,XorRes8 ; 0xE1
EbIb2 0x30,XorRes8 ; 0xE2
EbIbR2 0x30,XorRes8 ; 0xE3
EwIw xor,XorRes16 ; 0xE4
EwIwR 0x30,XorRes16 ; 0xE5
EwIb xor,XorRes16_2 ; 0xE6
EwIbR 0x30,XorRes16_2 ; 0xE7
EdId xor,XorRes32 ; 0xE8
EdIdR 0x30,XorRes32 ; 0xE9
EdIb xor,XorRes32_2 ; 0xEA
EdIbR 0x30,XorRes32_2 ; 0xEB

add di, 4 ; Skip 0xEC to 0xEF

EbIb cmp,CmpRes8 ; 0xF0
EbIbR 0x38,CmpRes8 ; 0xF1
EbIb2 0x38,CmpRes8 ; 0xF2
EbIbR2 0x38,CmpRes8 ; 0xF3
EwIw cmp,CmpRes16 ; 0xF4
EwIwR 0x38,CmpRes16 ; 0xF5
EwIb cmp,CmpRes16 ; 0xF6
EwIbR 0x38,CmpRes16 ; 0xF7
EdId cmp,CmpRes32 ; 0xF8
EdIdR 0x38,CmpRes32 ; 0xF9
EdIb cmp,CmpRes32 ; 0xFA
EdIbR 0x38,CmpRes32 ; 0xFB

add di, 4 ; Skip 0xFC to 0xFF

%define NSHIFT 3
%macro s_EbIb 2
mov byte [0], 0x12
clc
%1 byte [0], NSHIFT
cmp byte [0], %2
jnz .fail
inc di
%endmacro

%macro s_EbIbR 2
mov ah, 0x12
clc
%1 ah, NSHIFT
cmp ah, %2
jnz .fail
inc di
%endmacro

%macro s_EbCL 2
mov byte [0], 0x12
mov cl, NSHIFT
clc
%1 byte [0], cl
cmp byte [0], %2
jnz .fail
inc di
%endmacro

%macro s_EbCLR 2
mov ah, 0x12
mov cl, NSHIFT
clc
%1 ah, cl
cmp ah, %2
jnz .fail
inc di
%endmacro

%macro s_Eb1 2
mov byte [0], 0x12
clc
%1 byte [0], 1
cmp byte [0], %2
jnz .fail
inc di
%endmacro

%macro s_Eb1R 2
mov ah, 0x12
clc
%1 ah, 1
cmp ah, %2
jnz .fail
inc di
%endmacro

%macro s_EwIb 2
mov word [0], 0x1234
clc
%1 word [0], NSHIFT
cmp word [0], %2
jnz .fail
inc di
%endmacro

%macro s_EwIbR 2
mov bx, 0x1234
clc
%1 bx, NSHIFT
cmp bx, %2
jnz .fail
inc di
%endmacro

%macro s_EwCL 2
mov word [0], 0x1234
mov cl, NSHIFT
clc
%1 word [0], cl
cmp word [0], %2
jnz .fail
inc di
%endmacro

%macro s_EwCLR 2
mov bx, 0x1234
mov cl, NSHIFT
clc
%1 bx, cl
cmp bx, %2
jnz .fail
inc di
%endmacro

%macro s_Ew1 2
mov word [0], 0x1234
clc
%1 word [0], 1
cmp word [0], %2
jnz .fail
inc di
%endmacro

%macro s_Ew1R 2
mov bx, 0x1234
clc
%1 bx, 1
cmp bx, %2
jnz .fail
inc di
%endmacro

%macro s_EdIb 2
mov dword [0], 0x12345678
clc
%1 dword [0], NSHIFT
cmp dword [0], %2
jnz .fail
inc di
%endmacro

%macro s_EdIbR 2
mov ebx, 0x12345678
clc
%1 ebx, NSHIFT
cmp ebx, %2
jnz .fail
inc di
%endmacro

%macro s_EdCL 2
mov dword [0], 0x12345678
mov cl, NSHIFT
clc
%1 dword [0], cl
cmp dword [0], %2
jnz .fail
inc di
%endmacro

%macro s_EdCLR 2
mov ebx, 0x12345678
mov cl, NSHIFT
clc
%1 ebx, cl
cmp ebx, %2
jnz .fail
inc di
%endmacro

%macro s_Ed1 2
mov dword [0], 0x12345678
clc
%1 dword [0], 1
cmp dword [0], %2
jnz .fail
inc di
%endmacro

%macro s_Ed1R 2
mov ebx, 0x12345678
clc
%1 ebx, 1
cmp ebx, %2
jnz .fail
inc di
%endmacro

RolRes8 equ 0x90
RolRes8_1 equ 0x24
RolRes16 equ 0x91A0
RolRes16_1 equ 0x2468
RolRes32 equ 0x91A2B3C0
RolRes32_1 equ 0x2468ACF0
s_EbIb rol,RolRes8 ; 0x100
s_EbIbR rol,RolRes8 ; 0x101
s_EbCL rol,RolRes8 ; 0x102
s_EbCLR rol,RolRes8 ; 0x103
s_Eb1 rol,RolRes8_1 ; 0x104
s_Eb1R rol,RolRes8_1 ; 0x105
s_EwIb rol,RolRes16 ; 0x106
s_EwIbR rol,RolRes16 ; 0x107
s_EwCL rol,RolRes16 ; 0x108
s_EwCLR rol,RolRes16 ; 0x109
s_Ew1 rol,RolRes16_1 ; 0x10A
s_Ew1R rol,RolRes16_1 ; 0x10B
s_EdIb rol,RolRes32 ; 0x10C
s_EdIbR rol,RolRes32 ; 0x10D
s_EdCL rol,RolRes32 ; 0x10E
s_EdCLR rol,RolRes32 ; 0x10F
s_Ed1 rol,RolRes32_1 ; 0x110
s_Ed1R rol,RolRes32_1 ; 0x111

RorRes8 equ 0x42
RorRes8_1 equ 0x09
RorRes16 equ 0x8246
RorRes16_1 equ 0x091A
RorRes32 equ 0x02468ACF
RorRes32_1 equ 0x091A2B3C
s_EbIb ror,RorRes8 ; 0x112
s_EbIbR ror,RorRes8 ; 0x113
s_EbCL ror,RorRes8 ; 0x114
s_EbCLR ror,RorRes8 ; 0x115
s_Eb1 ror,RorRes8_1 ; 0x116
s_Eb1R ror,RorRes8_1 ; 0x117
s_EwIb ror,RorRes16 ; 0x118
s_EwIbR ror,RorRes16 ; 0x119
s_EwCL ror,RorRes16 ; 0x11A
s_EwCLR ror,RorRes16 ; 0x11B
s_Ew1 ror,RorRes16_1 ; 0x11C
s_Ew1R ror,RorRes16_1 ; 0x11D
s_EdIb ror,RorRes32 ; 0x11E
s_EdIbR ror,RorRes32 ; 0x11F
s_EdCL ror,RorRes32 ; 0x120
s_EdCLR ror,RorRes32 ; 0x121
s_Ed1 ror,RorRes32_1 ; 0x122
s_Ed1R ror,RorRes32_1 ; 0x123

s_EbIb rcl,RolRes8 ; 0x124
s_EbIbR rcl,RolRes8 ; 0x125
s_EbCL rcl,RolRes8 ; 0x126
s_EbCLR rcl,RolRes8 ; 0x127
s_Eb1 rcl,RolRes8_1 ; 0x128
s_Eb1R rcl,RolRes8_1 ; 0x129
s_EwIb rcl,RolRes16 ; 0x12A
s_EwIbR rcl,RolRes16 ; 0x12B
s_EwCL rcl,RolRes16 ; 0x12C
s_EwCLR rcl,RolRes16 ; 0x12D
s_Ew1 rcl,RolRes16_1 ; 0x12E
s_Ew1R rcl,RolRes16_1 ; 0x12F
s_EdIb rcl,RolRes32 ; 0x130
s_EdIbR rcl,RolRes32 ; 0x131
s_EdCL rcl,RolRes32 ; 0x132
s_EdCLR rcl,RolRes32 ; 0x133
s_Ed1 rcl,RolRes32_1 ; 0x134
s_Ed1R rcl,RolRes32_1 ; 0x135

RcrRes8 equ 0x82
RcrRes16 equ 0x246
RcrRes32 equ 0x02468ACF
s_EbIb rcr,RcrRes8 ; 0x136
s_EbIbR rcr,RcrRes8 ; 0x137
s_EbCL rcr,RcrRes8 ; 0x138
s_EbCLR rcr,RcrRes8 ; 0x139
s_Eb1 rcr,RorRes8_1 ; 0x13A
s_Eb1R rcr,RorRes8_1 ; 0x13B
s_EwIb rcr,RcrRes16 ; 0x13C
s_EwIbR rcr,RcrRes16 ; 0x13D
s_EwCL rcr,RcrRes16 ; 0x13E
s_EwCLR rcr,RcrRes16 ; 0x13F
s_Ew1 rcr,RorRes16_1 ; 0x140
s_Ew1R rcr,RorRes16_1 ; 0x141
s_EdIb rcr,RcrRes32 ; 0x142
s_EdIbR rcr,RcrRes32 ; 0x143
s_EdCL rcr,RcrRes32 ; 0x144
s_EdCLR rcr,RcrRes32 ; 0x145
s_Ed1 rcr,RorRes32_1 ; 0x146
s_Ed1R rcr,RorRes32_1 ; 0x147

ShlRes8 equ 0x90
ShlRes8_1 equ 0x24
ShlRes16 equ 0x91A0
ShlRes16_1 equ 0x2468
ShlRes32 equ 0x91A2B3C0
ShlRes32_1 equ 0x2468ACF0
s_EbIb shl,ShlRes8 ; 0x148
s_EbIbR shl,ShlRes8 ; 0x149
s_EbCL shl,ShlRes8 ; 0x14A
s_EbCLR shl,ShlRes8 ; 0x14B
s_Eb1 shl,ShlRes8_1 ; 0x14C
s_Eb1R shl,ShlRes8_1 ; 0x14D
s_EwIb shl,ShlRes16 ; 0x14E
s_EwIbR shl,ShlRes16 ; 0x14F
s_EwCL shl,ShlRes16 ; 0x150
s_EwCLR shl,ShlRes16 ; 0x151
s_Ew1 shl,ShlRes16_1 ; 0x152
s_Ew1R shl,ShlRes16_1 ; 0x153
s_EdIb shl,ShlRes32 ; 0x154
s_EdIbR shl,ShlRes32 ; 0x155
s_EdCL shl,ShlRes32 ; 0x156
s_EdCLR shl,ShlRes32 ; 0x157
s_Ed1 shl,ShlRes32_1 ; 0x158
s_Ed1R shl,ShlRes32_1 ; 0x159

ShrRes8 equ 2
ShrRes8_1 equ 9
ShrRes16 equ 0x0246
ShrRes16_1 equ 0x091A
ShrRes32 equ 0x02468ACF
ShrRes32_1 equ 0x091A2B3C
s_EbIb shr,ShrRes8 ; 0x15A
s_EbIbR shr,ShrRes8 ; 0x15B
s_EbCL shr,ShrRes8 ; 0x15C
s_EbCLR shr,ShrRes8 ; 0x15D
s_Eb1 shr,ShrRes8_1 ; 0x15E
s_Eb1R shr,ShrRes8_1 ; 0x15F
s_EwIb shr,ShrRes16 ; 0x160
s_EwIbR shr,ShrRes16 ; 0x161
s_EwCL shr,ShrRes16 ; 0x162
s_EwCLR shr,ShrRes16 ; 0x163
s_Ew1 shr,ShrRes16_1 ; 0x164
s_Ew1R shr,ShrRes16_1 ; 0x165
s_EdIb shr,ShrRes32 ; 0x166
s_EdIbR shr,ShrRes32 ; 0x167
s_EdCL shr,ShrRes32 ; 0x168
s_EdCLR shr,ShrRes32 ; 0x169
s_Ed1 shr,ShrRes32_1 ; 0x16A
s_Ed1R shr,ShrRes32_1 ; 0x16B

s_EbIb sar,ShrRes8 ; 0x15A
s_EbIbR sar,ShrRes8 ; 0x15B
s_EbCL sar,ShrRes8 ; 0x15C
s_EbCLR sar,ShrRes8 ; 0x15D
s_Eb1 sar,ShrRes8_1 ; 0x15E
s_Eb1R sar,ShrRes8_1 ; 0x15F
s_EwIb sar,ShrRes16 ; 0x160
s_EwIbR sar,ShrRes16 ; 0x161
s_EwCL sar,ShrRes16 ; 0x162
s_EwCLR sar,ShrRes16 ; 0x163
s_Ew1 sar,ShrRes16_1 ; 0x164
s_Ew1R sar,ShrRes16_1 ; 0x165
s_EdIb sar,ShrRes32 ; 0x166
s_EdIbR sar,ShrRes32 ; 0x167
s_EdCL sar,ShrRes32 ; 0x168
s_EdCLR sar,ShrRes32 ; 0x169
s_Ed1 sar,ShrRes32_1 ; 0x16A
s_Ed1R sar,ShrRes32_1 ; 0x16B

pop ds

jmp begintest

.failstr: db 'alu 0x$4 failed', 0
.fail: 
    ; We failed the basic opcode tests
    pop ds
    mov si, .failstr
    push word 0
    push di
    call printstr
    cli
    hlt

; Print, no carry tested. Format string should be in si
print_nc8_16: 
    push word 0
    push dx ; flags
    push word 0
    push ax ; res
    push word 0
    push cx ; op2
    push word 0
    push bx ; op1
    call printstr
    add sp, 4 * 4
    ret

print_nc32: 
    push word 0
    push dx ; flags
    push eax ; res
    push ecx ; op2
    push ebx ; op1
    call printstr
    add sp, 4 * 4
    ret

print_c8_16: 
    push word 0
    push dx ; flags
    push word 0
    push ax ; res
    push word 0
    push cx ; op2
    push word 0
    push bx ; op1
    push word 0
    push bp ; cf
    call printstr
    add sp, 5 * 4
    ret

print_c32: 
    push word 0
    push dx ; flags
    push eax ; res
    push ecx ; op2
    push ebx ; op1
    push word 0
    push bp ; cf
    call printstr
    add sp, 5 * 4
    ret

begintest: 

%macro ROT_FILTER_FLAGS 0
    and dx, 0x801
    push cx
    and cl, 0x1F
    cmp cl, 1
    jz %%done
    and dx, ~0x800
%%done: 
    pop cx
%endmacro

%macro SHIFT_FILTER_FLAGS 0
    and dx, ~0x10 ; ignore af
    push cx
    and cl, 0x1F
    cmp cl, 1
    jz %%done
    and dx, ~0x800
%%done: 
    pop cx
%endmacro

; Here are the tests that print out results+flags
%define vax al 
%define vcx cl 
%define vbx bl

%define print_c print_c8_16
%define print_nc print_nc8_16

%define TESTCASE_TBL_OP1 testcase8_op1
%define TESTCASE_TBL_OP2 testcase8_op2

%define TESTID add8
%define TESTSTR "add8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN add
%include "testalu.asm"

%define TESTID or8
%define TESTSTR "or8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN or
%include "testalu.asm"

%define CARRY_TEST
%define TESTID adc8
%define TESTSTR "adc8 cf=$1 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN adc
%include "testalu.asm"

%define TESTID sbb8
%define TESTSTR "sbb8 cf=$1 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN sbb
%include "testalu.asm"

%undef CARRY_TEST

%define TESTID and8
%define TESTSTR "and8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN and
%include "testalu.asm"

%define TESTID sub8
%define TESTSTR "sub8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN sub
%include "testalu.asm"

%define TESTID xor8
%define TESTSTR "xor8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN xor
%include "testalu.asm"

%define TESTID cmp8
%define TESTSTR "cmp8 op1=$2 op2=$2 ignore=$2 fl=$4"
%define TESTINSN cmp
%include "testalu.asm"

; Shift/rotate operations

%undef TESTCASE_TBL_OP1 
%undef TESTCASE_TBL_OP2
%define TESTCASE_TBL_OP1 testcase8_ror_op1
%define TESTCASE_TBL_OP2 testcase8_ror_op2

%define FILTERFLAGS_MACRO ROT_FILTER_FLAGS

%define TESTID ror8
%define TESTSTR "ror8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN ror
%include "testalu.asm"

%define TESTID rol8
%define TESTSTR "rol8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN rol
%include "testalu.asm"

%define CARRY_TEST
%define TESTID rcr8
%define TESTSTR "rcr8 cf=$1 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN rcr
%include "testalu.asm"

%define TESTID rcl8
%define TESTSTR "rcl8 cf=$1 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN rcl
%include "testalu.asm"

%undef CARRY_TEST
%undef FILTERFLAGS_MACRO
%define FILTERFLAGS_MACRO SHIFT_FILTER_FLAGS

%define TESTID shl8
%define TESTSTR "shl8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN shl
%include "testalu.asm"

%define TESTID shr8
%define TESTSTR "shr8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN shr
%include "testalu.asm"

%define TESTID sar8
%define TESTSTR "sar8 op1=$2 op2=$2 res=$2 fl=$4"
%define TESTINSN sar
%include "testalu.asm"

%undef FILTERFLAGS_MACRO

%undef TESTCASE_TBL_OP1 
%undef TESTCASE_TBL_OP2
%define TESTCASE_TBL_OP1 testcase16_op1
%define TESTCASE_TBL_OP2 testcase16_op2

%undef vax
%undef vcx
%undef vbx
%define vax ax
%define vcx cx 
%define vbx bx

%define print_c print_c8_16
%define print_nc print_nc8_16

%define TESTID add16
%define TESTSTR "add16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN add
%include "testalu.asm"

%define TESTID or16
%define TESTSTR "or16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN or
%include "testalu.asm"

%define CARRY_TEST
%define TESTID adc16
%define TESTSTR "adc16 cf=$1 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN adc
%include "testalu.asm"

%define TESTID sbb16
%define TESTSTR "sbb16 cf=$1 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN sbb
%include "testalu.asm"

%undef CARRY_TEST

%define TESTID and16
%define TESTSTR "and16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN and
%include "testalu.asm"

%define TESTID sub16
%define TESTSTR "sub16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN sub
%include "testalu.asm"

%define TESTID xor16
%define TESTSTR "xor16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN xor
%include "testalu.asm"

%define TESTID cmp16
%define TESTSTR "cmp16 op1=$4 op2=$4 ignore=$4 fl=$4"
%define TESTINSN cmp
%include "testalu.asm"

%undef vcx
%define vcx cl

%define FILTERFLAGS_MACRO ROT_FILTER_FLAGS

%undef TESTCASE_TBL_OP1 
%undef TESTCASE_TBL_OP2
%define TESTCASE_TBL_OP1 testcase16_ror_op1
%define TESTCASE_TBL_OP2 testcase16_ror_op2

%define TESTID ror16
%define TESTSTR "ror16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN ror
%include "testalu.asm"

%define TESTID rol16
%define TESTSTR "rol16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN rol
%include "testalu.asm"

%define CARRY_TEST
%define TESTID rcr16
%define TESTSTR "rcr16 cf=$1 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN rcr
%include "testalu.asm"

%define TESTID rcl16
%define TESTSTR "rcl16 cf=$1 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN rcl
%include "testalu.asm"

%undef FILTERFLAGS_MACRO
%define FILTERFLAGS_MACRO SHIFT_FILTER_FLAGS

%undef CARRY_TEST

%define TESTID shl16
%define TESTSTR "shl16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN shl
%include "testalu.asm"

%define TESTID shr16
%define TESTSTR "shr16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN shr
%include "testalu.asm"

%define TESTID sar16
%define TESTSTR "sar16 op1=$4 op2=$4 res=$4 fl=$4"
%define TESTINSN sar

%undef FILTERFLAGS_MACRO

; Finally, 32-bit operations

%undef TESTCASE_TBL_OP1 
%undef TESTCASE_TBL_OP2
%define TESTCASE_TBL_OP1 testcase32_op1
%define TESTCASE_TBL_OP2 testcase32_op2

%undef vax
%undef vcx
%undef vbx
%define vax eax
%define vcx ecx 
%define vbx ebx

%define print_c print_c32
%define print_nc print_nc32

%define TESTID add32
%define TESTSTR "add32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN add
%include "testalu.asm"

%define TESTID or32
%define TESTSTR "or32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN or
%include "testalu.asm"

%define CARRY_TEST
%define TESTID adc32
%define TESTSTR "adc32 cf=$1 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN adc
%include "testalu.asm"

%define TESTID sbb32
%define TESTSTR "sbb32 cf=$1 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN sbb
%include "testalu.asm"

%undef CARRY_TEST

%define TESTID and32
%define TESTSTR "and32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN and
%include "testalu.asm"

%define TESTID sub32
%define TESTSTR "sub32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN sub
%include "testalu.asm"

%define TESTID xor32
%define TESTSTR "xor32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN xor
%include "testalu.asm"

%define TESTID cmp32
%define TESTSTR "cmp32 op1=$8 op2=$8 ignore=$8 fl=$4"
%define TESTINSN cmp
%include "testalu.asm"

%undef vcx
%define vcx cl

%define FILTERFLAGS_MACRO ROT_FILTER_FLAGS

%undef TESTCASE_TBL_OP1 
%undef TESTCASE_TBL_OP2
%define TESTCASE_TBL_OP1 testcase32_ror_op1
%define TESTCASE_TBL_OP2 testcase32_ror_op2

%define TESTID ror32
%define TESTSTR "ror32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN ror
%include "testalu.asm"

%define TESTID rol32
%define TESTSTR "rol32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN rol
%include "testalu.asm"

%define CARRY_TEST
%define TESTID rcr32
%define TESTSTR "rcr32 cf=$1 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN rcr
%include "testalu.asm"

%define TESTID rcl32
%define TESTSTR "rcl32 cf=$1 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN rcl
%include "testalu.asm"

%undef CARRY_TEST
%undef FILTERFLAGS_MACRO
%define FILTERFLAGS_MACRO SHIFT_FILTER_FLAGS

%define TESTID shl32
%define TESTSTR "shl32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN shl
%include "testalu.asm"

%define TESTID shr32
%define TESTSTR "shr32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN shr
%include "testalu.asm"

%define TESTID sar32
%define TESTSTR "sar32 op1=$8 op2=$8 res=$8 fl=$4"
%define TESTINSN sar
%include "testalu.asm"

%undef FILTERFLAGS_MACRO

test_muldiv_encodings: 

; Save DS; ES = DS
push ds
push es
pop ds 

xor di, di

%macro mul_ALEb 2
    mov al, 0x03
    mov cl, 0xAA
    %1 cl
    cmp ax, %2
    jnz .fail 
    inc di

    mov al, 0x03
    mov byte [0], 0xAA
    %1 byte [0]
    cmp ax, %2
    jnz .fail
    inc di
%endmacro

%macro mul_AXEw 2
    mov ax, 0x0003
    mov cx, 0xAAAA
    %1 cx
    cmp ax, (%2 & 0xFFFF)
    jnz .fail
    cmp dx, ((%2 >> 16) & 0xFFFF)
    jnz .fail
    inc di

    mov ax, 0x0003
    mov word [0], 0xAAAA
    %1 word [0]
    cmp ax, (%2 & 0xFFFF)
    jnz .fail
    cmp dx, ((%2 >> 16) & 0xFFFF)
    jnz .fail
    inc di
%endmacro

%macro mul_EAXEd 3
    mov eax, 0x00000003
    mov ecx, 0xAAAAAAAA
    %1 ecx
    cmp eax, %3
    jnz .fail
    cmp edx, %2
    jnz .fail
    inc di

    mov eax, 0x00000003
    mov dword [0], 0xAAAAAAAA
    %1 dword [0]
    cmp eax, %3
    jnz .fail
    cmp edx, %2
    jnz .fail
    inc di
%endmacro

; Test all imul encodings
mul_ALEb imul,0xFEFE ; 0x00, 0x01
mul_AXEw imul,0xFFFEFFFE ; 0x02, 0x03
mul_EAXEd imul,0xFFFFFFFE,0xFFFFFFFE ; 0x04, 0x05

; imul r16, r/m16 - 0x06
mov ax, 0x0003
mov cx, 0xAAAA
imul ax, cx
cmp ax, 0xFFFE
jnz .fail
inc di

; 0x07
mov ax, 0x0003
mov word [0], 0xAAAA
imul ax, word [0]
cmp ax, 0xFFFE
jnz .fail
inc di

; imul r32, r/m32 - 0x08
mov eax, 0x00000003
mov ecx, 0xAAAAAAAA
imul eax, ecx
cmp eax, 0xFFFFFFFE
jnz .fail
inc di

; 0x09
mov eax, 0x00000003
mov dword [0], 0xAAAAAAAA
imul eax, dword [0]
cmp eax, 0xFFFFFFFE
jnz .fail
inc di

; imul r16, r/m16, imm8 - 0x0A
; NASM refuses to generate this instruction with an imm8, so we encode it ourselves
mov cx, 0x0003
; opcode
db 0x6B
; modrm
;  Mod=3
;  Reg=0 (ax - dest)
;  R/m=1 (cx - src1)
db 0xC1
; imm - src2
db 0x80
;imul ax, cx, 0xFFFFFF80
cmp ax, 0xFE80
jnz .fail
inc di

; 0x0B
mov word [0], 0x0003
; opcode
db 0x6B
; modrm
;  Mod=0
;  Reg=0 (ax - dest)
;  R/m=6 (disp16 - src1)
db 0x06
; disp16 - word [0]
dw 0
; imm - src2
db 0x80
;imul ax, cx, 0xFFFF
;imul ax, word [0], 0x80
cmp ax, 0xFE80
jnz .fail
inc di

; imul r32, r/m32, imm8 - 0x0C
mov ecx, 0x00000003
db 0x66
db 0x6B
db 0xC1
db 0x80
cmp eax, 0xFFFFFE80
jnz .fail
inc di

; 0x0D
mov dword [0], 0x00000003
db 0x66
db 0x6B
db 0x06
dw 0
db 0x80
cmp eax, 0xFFFFFE80
jnz .fail
inc di

; Two-operand form: reg=0, r/m=0 - 0x0E
mov ax, 0x0003
; opcode
db 0x6B
; modrm
;  Mod=3
;  Reg=0 (ax - dest)
;  R/m=0 (ax - src1)
db 0xC0
; imm - src2
db 0x80
cmp ax, 0xFE80
jnz .fail
inc di

; 32-bit version: 0x0F
mov eax, 0x00000003
db 0x66
db 0x6B
db 0xC0
db 0x80
cmp eax, 0xFFFFFE80
jnz .fail
inc di

; 16-bit and 32-bit immediates, 3-operand - 0x10
mov cx, 0x0003
imul ax, cx, 0xAAAA
cmp ax, 0xFFFE
jnz .fail
inc di

; 0x11
mov word [0], 0x0003
imul ax, word [0], 0xAAAA
cmp ax, 0xFFFE
jnz .fail
inc di

; 0x12
mov ecx, 0x00000003
imul eax, ecx, 0xAAAAAAAA
cmp eax, 0xFFFFFFFE
jnz .fail
inc di

; 0x13
mov dword [0], 0x00000003
imul eax, dword [0], 0xAAAAAAAA
cmp eax, 0xFFFFFFFE
jnz .fail
inc di

; Test all mul encodings
mul_ALEb mul,0x1FE ; 0x14, 0x15
mul_AXEw mul,0x1FFFE ; 0x16, 0x17
mul_EAXEd mul,1,0xFFFFFFFE ; 0x18, 0x19

jmp test_muldiv_results

.failstr: db "muldiv 0x$2 fail", 0
.fail:
    pop ds
    mov si, .failstr
    push word 0
    push di
    call printstr
    cli 
    hlt

test_muldiv_results:
pop ds

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

testcase8_ror_op1:
    dd 0x80 ; tests OF condition, ROR
    dd 0x01 ; tests OF condition, ROR and ROL
    dd 0x02 ; tests OF condition, ROL
    dd 0x34
    dd 0x6F
    dd 0x80
    dd 0x09
    dd 0xF5

testcase8_ror_op2: 
    dd 0
    dd 1
    dd 8
    dd 9
    dd 16
    dd 17
    dd 32
    dd 0x41

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

testcase16_ror_op1:
    dd 0x8000 ; tests OF condition, ROR
    dd 0x0001 ; tests OF condition, ROR and ROL
    dd 0x0002 ; tests OF condition, ROL
    dd 0x3456
    dd 0x6FF4
    dd 0x8000
    dd 0x0009
    dd 0xF53D

testcase16_ror_op2: 
    dd 0
    dd 1
    dd 8
    dd 9
    dd 16
    dd 17
    dd 32
    dd 0x41

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

testcase32_ror_op1:
    dd 0x80000000 ; tests OF condition, ROR
    dd 0x00000001 ; tests OF condition, ROR and ROL
    dd 0x00000002 ; tests OF condition, ROL
    dd 0x3456789A
    dd 0x6FF43960
    dd 0x80000000
    dd 0x00000009
    dd 0xF53D9632

testcase32_ror_op2: 
    dd 0
    dd 1
    dd 8
    dd 9
    dd 16
    dd 17
    dd 32
    dd 0x41