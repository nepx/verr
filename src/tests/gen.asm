%line 2+1 alu.asm

%line 7+1 alu.asm




push ds


push es
pop ds

%line 26+1 alu.asm

%line 36+1 alu.asm

%line 52+1 alu.asm

%line 68+1 alu.asm


%line 79+1 alu.asm

%line 88+1 alu.asm

%line 104+1 alu.asm

%line 120+1 alu.asm


%line 131+1 alu.asm

%line 140+1 alu.asm

xor dx, dx
AddRes8 equ (0x55+0xAA)&0xFF
AddRes16 equ (0x5555+0xAAAA)&0xFFFF
AddRes32 equ (0x555555555+0xAAAAAAAA)&0xFFFFFFFF

mov byte [0], 0x55
%line 146+0 alu.asm
mov ch, 0xAA
clc
add byte [0], ch
cmp byte [0], AddRes8
jnz fail
inc dx
%line 147+1 alu.asm
mov ch, 0x55
%line 147+0 alu.asm
mov byte [0], 0xAA
clc
add ch, byte [0]
cmp ch, AddRes8
jnz fail
inc dx
%line 148+1 alu.asm
mov ch, 0xAA
%line 148+0 alu.asm
mov bl, 0x55
clc

db 0x00




db 0xDE
cmp bl, AddRes8
jnz fail
inc dx
%line 149+1 alu.asm
mov bx, 0x55
%line 149+0 alu.asm
mov si, 0xAA
clc

db 0x00




db 0xDE
cmp bx, AddRes8
jnz fail
inc dx
%line 150+1 alu.asm

mov word [0], 0x5555
%line 151+0 alu.asm
mov cx, 0xAAAA
clc
add word [0], cx
cmp word [0], AddRes16
jnz fail
inc dx
%line 152+1 alu.asm
mov cx, 0x5555
%line 152+0 alu.asm
mov word [0], 0xAAAA
clc
add cx, word [0]
cmp cx, AddRes16
jnz fail
%line 153+1 alu.asm
mov dword [0], 0x55555555
%line 153+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
add dword [0], ecx
cmp dword [0], AddRes32
jnz fail
inc dx
%line 154+1 alu.asm
mov ecx, 0x55555555
%line 154+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
add ecx, dword [0]
cmp ecx, AddRes32
jnz fail
%line 155+1 alu.asm
mov bx, 0xAA
%line 155+0 alu.asm
mov si, 0x55
clc

db 0x00




db 0xDE
cmp si, AddRes16
jnz fail
inc dx
%line 156+1 alu.asm
GwEwR 0x00,AddRes16

OrRes8 equ (0x55|0xAA)&0xFF
mov byte [0], 0x55
%line 159+0 alu.asm
mov ch, 0xAA
clc
or byte [0], ch
cmp byte [0], OrRes8
jnz fail
inc dx
%line 160+1 alu.asm

mov byte [0], 0x55
%line 161+0 alu.asm
mov ch, 0xAA
clc
adc byte [0], ch
cmp byte [0], AddRes8
jnz fail
inc dx
%line 162+1 alu.asm

SubRes8 equ (0x55-0xAA)&0xFF
mov byte [0], 0x55
%line 164+0 alu.asm
mov ch, 0xAA
clc
sbb byte [0], ch
cmp byte [0], SubRes8
jnz fail
inc dx
%line 165+1 alu.asm

AndRes8 equ (0x55&0xAA)&0xFF
mov byte [0], 0x55
%line 167+0 alu.asm
mov ch, 0xAA
clc
and byte [0], ch
cmp byte [0], AndRes8
jnz fail
inc dx
%line 168+1 alu.asm

mov byte [0], 0x55
%line 169+0 alu.asm
mov ch, 0xAA
clc
sub byte [0], ch
cmp byte [0], SubRes8
jnz fail
inc dx
%line 170+1 alu.asm

XorRes8 equ (0x55^0xAA)&0xFF
mov byte [0], 0x55
%line 172+0 alu.asm
mov ch, 0xAA
clc
xor byte [0], ch
cmp byte [0], XorRes8
jnz fail
inc dx
%line 173+1 alu.asm

CmpRes8 equ 0x55
mov byte [0], 0x55
%line 175+0 alu.asm
mov ch, 0xAA
clc
sub byte [0], ch
cmp byte [0], CmpRes8
jnz fail
inc dx
%line 176+1 alu.asm

jmp begintest

failstr: db 'alu 0x$2 failed'
fail:

 mov si, failstr
 push dx
 push word 0
 call printstr
 cli
 hlt


print_nc:
 vpush vdx
 push32 eax
 push32 ecx
 push32 ebx
 call printstr
 add vsp, 4 * 4
 ret

print_c:
 vpush vdx
 push32 eax
 push32 ecx
 push32 ebx
 vpush vcx
 call printstr
 add vsp, 5 * 4
 ret

begintest:


%line 214+1 alu.asm

%line 1+1 testalu.asm
add8:
 xor vbx, vbx
 xor vdi, vdi


 xor eax, eax
 mov ecx, eax

 mov vsi, .str
 jmp .optest
.str: db "add8 $2+$2=$2 fl=$4", 0
.optest:

 mov eax, [testcase8_op1 + vbx]
 mov ecx, [testcase8_op2 + vdi]
 mov ebx, eax

 add al, cl


 pushfw
%line 21+0 testalu.asm
 pop word vdx
%line 26+1 testalu.asm
 call print_nc


%line 37+1 testalu.asm
 add vbx, 4
 cmp vbx, (8 * 4)
 jnz .optest


 xor vbx, vbx
 add vdi, 4
 cmp vdi, (8 * 4)
 jnz .optest

%line 219+1 alu.asm

%line 1+1 testalu.asm
or8:
 xor vbx, vbx
 xor vdi, vdi


 xor eax, eax
 mov ecx, eax

 mov vsi, .str
 jmp .optest
.str: db "or8 $2|$2=$2 fl=$4", 0
.optest:

 mov eax, [testcase8_op1 + vbx]
 mov ecx, [testcase8_op2 + vdi]
 mov ebx, eax

 or al, cl


 pushfw
%line 21+0 testalu.asm
 pop word vdx
%line 26+1 testalu.asm
 call print_nc


%line 37+1 testalu.asm
 add vbx, 4
 cmp vbx, (8 * 4)
 jnz .optest


 xor vbx, vbx
 add vdi, 4
 cmp vdi, (8 * 4)
 jnz .optest

%line 224+1 alu.asm

%line 1+1 testalu.asm
adc8:
 xor vbx, vbx
 xor vdi, vdi


 xor eax, eax
 mov ecx, eax

 mov vsi, .str
 jmp .optest
.str: db "adc8 $1+$2+$2=$2 fl=$4", 0
.optest:

 mov eax, [testcase8_op1 + vbx]
 mov ecx, [testcase8_op2 + vdi]
 mov ebx, eax

 adc al, cl


 pushfw
%line 21+0 testalu.asm
 pop word vdx
%line 23+1 testalu.asm
 xor vbp, vbp
 call print_c
%line 28+1 testalu.asm


 stc
 mov ebx, eax
 adc al, cl
 pushfw
%line 33+0 testalu.asm
 pop word vdx
%line 34+1 testalu.asm
 inc vbp
 call print_c

 add vbx, 4
 cmp vbx, (8 * 4)
 jnz .optest


 xor vbx, vbx
 add vdi, 4
 cmp vdi, (8 * 4)
 jnz .optest

%line 230+1 alu.asm

%line 1+1 testalu.asm
sbb8:
 xor vbx, vbx
 xor vdi, vdi


 xor eax, eax
 mov ecx, eax

 mov vsi, .str
 jmp .optest
.str: db "sbb8 -$1+$2-$2=$2 fl=$4", 0
.optest:

 mov eax, [testcase8_op1 + vbx]
 mov ecx, [testcase8_op2 + vdi]
 mov ebx, eax

 sbb al, cl


 pushfw
%line 21+0 testalu.asm
 pop word vdx
%line 23+1 testalu.asm
 xor vbp, vbp
 call print_c
%line 28+1 testalu.asm


 stc
 mov ebx, eax
 sbb al, cl
 pushfw
%line 33+0 testalu.asm
 pop word vdx
%line 34+1 testalu.asm
 inc vbp
 call print_c

 add vbx, 4
 cmp vbx, (8 * 4)
 jnz .optest


 xor vbx, vbx
 add vdi, 4
 cmp vdi, (8 * 4)
 jnz .optest

%line 235+1 alu.asm

cli
hlt

testcase8_op1:
 dd 0x12
 dd -0x12
 dd 0x7F
 dd 0x80
 dd 0xFF
 dd 0x00
 dd 0x0F
 dd 0x10

testcase8_op2:
 dd 0x34
 dd -0x34
 dd 0
 dd 1
 dd 2
 dd -1
 dd -2
 dd 0x55

testcase16_op1:
 dd 0x1234
 dd -0x1234
 dd 0x7FFF
 dd 0x8000
 dd 0xFFFF
 dd 0x0000
 dd 0x000F
 dd 0x0010

testcase16_op2:
 dd 0x5678
 dd -0x5678
 dd 0
 dd 1
 dd 2
 dd -1
 dd -2
 dd 0x55AA

testcase32_op1:
 dd 0x12345678
 dd -0x12345678
 dd 0x7FFFFFFF
 dd 0x80000000
 dd 0xFFFFFFFF
 dd 0x00000000
 dd 0x0000000F
 dd 0x00000010

testcase32_op2:
 dd 0x9ABCDEF0
 dd (-0x9ABCDEF0) & 0xFFFFFFFF
 dd 0
 dd 1
 dd 2
 dd -1
 dd -2
 dd 0x55AA55AA
