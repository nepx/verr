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

%line 89+1 alu.asm

%line 105+1 alu.asm

%line 121+1 alu.asm


%line 132+1 alu.asm

%line 142+1 alu.asm

%line 160+1 alu.asm

%line 178+1 alu.asm


%line 188+1 alu.asm

%line 196+1 alu.asm

%line 204+1 alu.asm

xor dx, dx
AddRes8 equ (0x55+0xAA)&0xFF
AddRes16 equ (0x5555+0xAAAA)&0xFFFF
AddRes32 equ (0x55555555+0xAAAAAAAA)&0xFFFFFFFF

mov byte [0], 0x55
%line 210+0 alu.asm
mov ch, 0xAA
clc
add byte [0], ch
cmp byte [0], AddRes8
jnz fail
inc dx
%line 211+1 alu.asm
mov ch, 0x55
%line 211+0 alu.asm
mov byte [0], 0xAA
clc
add ch, byte [0]
cmp ch, AddRes8
jnz fail
inc dx
%line 212+1 alu.asm
mov bl, 0xAA
%line 212+0 alu.asm
mov dh, 0x55
clc

db 0x00




db 0xDE
cmp dh, AddRes8
jnz fail
inc dx
%line 213+1 alu.asm
mov bl, 0x55
%line 213+0 alu.asm
mov dh, 0xAA
clc

db 0x00 | 0x02




db 0xDE
cmp bl, AddRes8
jnz fail
inc dx
%line 214+1 alu.asm

mov word [0], 0x5555
%line 215+0 alu.asm
mov cx, 0xAAAA
clc
add word [0], cx
cmp word [0], AddRes16
jnz fail
inc dx
%line 216+1 alu.asm
mov cx, 0x5555
%line 216+0 alu.asm
mov word [0], 0xAAAA
clc
add cx, word [0]
cmp cx, AddRes16
jnz fail
inc dx
%line 217+1 alu.asm
mov dword [0], 0x55555555
%line 217+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
add dword [0], ecx
cmp dword [0], AddRes32
jnz fail
inc dx
%line 218+1 alu.asm
mov ecx, 0x55555555
%line 218+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
add ecx, dword [0]
cmp ecx, AddRes32
jnz fail
inc dx
%line 219+1 alu.asm
mov bx, 0xAAAA
%line 219+0 alu.asm
mov si, 0x5555
clc

db 0x00 | 0x01




db 0xDE
cmp si, AddRes16
jnz fail
inc dx
%line 220+1 alu.asm
mov bx, 0x5555
%line 220+0 alu.asm
mov si, 0xAAAA
clc

db 0x00 | 0x03




db 0xDE
cmp bx, AddRes16
jnz fail
inc dx
%line 221+1 alu.asm
mov ebx, 0xAAAAAAAA
%line 221+0 alu.asm
mov esi, 0x55555555
clc

db 0x66

db 0x00 | 0x01




db 0xDE
cmp esi, AddRes32
jnz fail
inc dx
%line 222+1 alu.asm
mov ebx, 0x55555555
%line 222+0 alu.asm
mov esi, 0xAAAAAAAA
clc

db 0x66

db 0x00 | 0x03




db 0xDE
cmp ebx, AddRes32
jnz fail
inc dx
%line 223+1 alu.asm

mov al, 0x55
%line 224+0 alu.asm

add al, 0xAA
cmp al, AddRes8
jnz fail
inc dx
%line 225+1 alu.asm
mov ax, 0x5555
%line 225+0 alu.asm
add ax, 0xAAAA
cmp ax, AddRes16
jnz fail
inc dx
%line 226+1 alu.asm
mov eax, 0x55555555
%line 226+0 alu.asm
add eax, 0xAAAAAAAA
cmp eax, AddRes32
jnz fail
inc dx
%line 227+1 alu.asm
inc dx

OrRes8 equ (0x55|0xAA)&0xFF
OrRes16 equ (0x5555|0xAAAA)&0xFFFF
OrRes32 equ (0x55555555|0xAAAAAAAA)&0xFFFFFFFF

mov byte [0], 0x55
%line 233+0 alu.asm
mov ch, 0xAA
clc
or byte [0], ch
cmp byte [0], OrRes8
jnz fail
inc dx
%line 234+1 alu.asm
mov ch, 0x55
%line 234+0 alu.asm
mov byte [0], 0xAA
clc
or ch, byte [0]
cmp ch, OrRes8
jnz fail
inc dx
%line 235+1 alu.asm
mov bl, 0xAA
%line 235+0 alu.asm
mov dh, 0x55
clc

db 0x08




db 0xDE
cmp dh, OrRes8
jnz fail
inc dx
%line 236+1 alu.asm
mov bl, 0x55
%line 236+0 alu.asm
mov dh, 0xAA
clc

db 0x08 | 0x02




db 0xDE
cmp bl, OrRes8
jnz fail
inc dx
%line 237+1 alu.asm

mov word [0], 0x5555
%line 238+0 alu.asm
mov cx, 0xAAAA
clc
or word [0], cx
cmp word [0], OrRes16
jnz fail
inc dx
%line 239+1 alu.asm
mov cx, 0x5555
%line 239+0 alu.asm
mov word [0], 0xAAAA
clc
or cx, word [0]
cmp cx, OrRes16
jnz fail
inc dx
%line 240+1 alu.asm
mov dword [0], 0x55555555
%line 240+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
or dword [0], ecx
cmp dword [0], OrRes32
jnz fail
inc dx
%line 241+1 alu.asm
mov ecx, 0x55555555
%line 241+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
or ecx, dword [0]
cmp ecx, OrRes32
jnz fail
inc dx
%line 242+1 alu.asm
mov bx, 0xAAAA
%line 242+0 alu.asm
mov si, 0x5555
clc

db 0x08 | 0x01




db 0xDE
cmp si, OrRes16
jnz fail
inc dx
%line 243+1 alu.asm
mov bx, 0x5555
%line 243+0 alu.asm
mov si, 0xAAAA
clc

db 0x08 | 0x03




db 0xDE
cmp bx, OrRes16
jnz fail
inc dx
%line 244+1 alu.asm
mov ebx, 0xAAAAAAAA
%line 244+0 alu.asm
mov esi, 0x55555555
clc

db 0x66

db 0x08 | 0x01




db 0xDE
cmp esi, OrRes32
jnz fail
inc dx
%line 245+1 alu.asm
mov ebx, 0x55555555
%line 245+0 alu.asm
mov esi, 0xAAAAAAAA
clc

db 0x66

db 0x08 | 0x03




db 0xDE
cmp ebx, OrRes32
jnz fail
inc dx
%line 246+1 alu.asm

mov al, 0x55
%line 247+0 alu.asm

or al, 0xAA
cmp al, OrRes8
jnz fail
inc dx
%line 248+1 alu.asm
mov ax, 0x5555
%line 248+0 alu.asm
or ax, 0xAAAA
cmp ax, OrRes16
jnz fail
inc dx
%line 249+1 alu.asm
mov eax, 0x55555555
%line 249+0 alu.asm
or eax, 0xAAAAAAAA
cmp eax, OrRes32
jnz fail
inc dx
%line 250+1 alu.asm
inc dx


mov byte [0], 0x55
%line 253+0 alu.asm
mov ch, 0xAA
clc
adc byte [0], ch
cmp byte [0], AddRes8
jnz fail
inc dx
%line 254+1 alu.asm
mov ch, 0x55
%line 254+0 alu.asm
mov byte [0], 0xAA
clc
adc ch, byte [0]
cmp ch, AddRes8
jnz fail
inc dx
%line 255+1 alu.asm
mov bl, 0xAA
%line 255+0 alu.asm
mov dh, 0x55
clc

db 0x10




db 0xDE
cmp dh, AddRes8
jnz fail
inc dx
%line 256+1 alu.asm
mov bl, 0x55
%line 256+0 alu.asm
mov dh, 0xAA
clc

db 0x10 | 0x02




db 0xDE
cmp bl, AddRes8
jnz fail
inc dx
%line 257+1 alu.asm

mov word [0], 0x5555
%line 258+0 alu.asm
mov cx, 0xAAAA
clc
adc word [0], cx
cmp word [0], AddRes16
jnz fail
inc dx
%line 259+1 alu.asm
mov cx, 0x5555
%line 259+0 alu.asm
mov word [0], 0xAAAA
clc
adc cx, word [0]
cmp cx, AddRes16
jnz fail
inc dx
%line 260+1 alu.asm
mov dword [0], 0x55555555
%line 260+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
adc dword [0], ecx
cmp dword [0], AddRes32
jnz fail
inc dx
%line 261+1 alu.asm
mov ecx, 0x55555555
%line 261+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
adc ecx, dword [0]
cmp ecx, AddRes32
jnz fail
inc dx
%line 262+1 alu.asm
mov bx, 0xAAAA
%line 262+0 alu.asm
mov si, 0x5555
clc

db 0x10 | 0x01




db 0xDE
cmp si, AddRes16
jnz fail
inc dx
%line 263+1 alu.asm
mov bx, 0x5555
%line 263+0 alu.asm
mov si, 0xAAAA
clc

db 0x10 | 0x03




db 0xDE
cmp bx, AddRes16
jnz fail
inc dx
%line 264+1 alu.asm
mov ebx, 0xAAAAAAAA
%line 264+0 alu.asm
mov esi, 0x55555555
clc

db 0x66

db 0x10 | 0x01




db 0xDE
cmp esi, AddRes32
jnz fail
inc dx
%line 265+1 alu.asm
mov ebx, 0x55555555
%line 265+0 alu.asm
mov esi, 0xAAAAAAAA
clc

db 0x66

db 0x10 | 0x03




db 0xDE
cmp ebx, AddRes32
jnz fail
inc dx
%line 266+1 alu.asm

mov al, 0x55
%line 267+0 alu.asm

adc al, 0xAA
cmp al, AddRes8
jnz fail
inc dx
%line 268+1 alu.asm
mov ax, 0x5555
%line 268+0 alu.asm
adc ax, 0xAAAA
cmp ax, AddRes16
jnz fail
inc dx
%line 269+1 alu.asm
mov eax, 0x55555555
%line 269+0 alu.asm
adc eax, 0xAAAAAAAA
cmp eax, AddRes32
jnz fail
inc dx
%line 270+1 alu.asm
inc dx

SubRes8 equ (0x55-0xAA)&0xFF
SubRes16 equ (0x5555-0xAAAA)&0xFFFF
SubRes32 equ (0x55555555-0xAAAAAAAA)&0xFFFFFFFF
mov byte [0], 0x55
%line 275+0 alu.asm
mov ch, 0xAA
clc
sbb byte [0], ch
cmp byte [0], SubRes8
jnz fail
inc dx
%line 276+1 alu.asm
mov ch, 0x55
%line 276+0 alu.asm
mov byte [0], 0xAA
clc
sbb ch, byte [0]
cmp ch, SubRes8
jnz fail
inc dx
%line 277+1 alu.asm
mov bl, 0xAA
%line 277+0 alu.asm
mov dh, 0x55
clc

db 0x18




db 0xDE
cmp dh, SubRes8
jnz fail
inc dx
%line 278+1 alu.asm
mov bl, 0x55
%line 278+0 alu.asm
mov dh, 0xAA
clc

db 0x18 | 0x02




db 0xDE
cmp bl, SubRes8
jnz fail
inc dx
%line 279+1 alu.asm

mov word [0], 0x5555
%line 280+0 alu.asm
mov cx, 0xAAAA
clc
sbb word [0], cx
cmp word [0], SubRes16
jnz fail
inc dx
%line 281+1 alu.asm
mov cx, 0x5555
%line 281+0 alu.asm
mov word [0], 0xAAAA
clc
sbb cx, word [0]
cmp cx, SubRes16
jnz fail
inc dx
%line 282+1 alu.asm
mov dword [0], 0x55555555
%line 282+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
sbb dword [0], ecx
cmp dword [0], SubRes32
jnz fail
inc dx
%line 283+1 alu.asm
mov ecx, 0x55555555
%line 283+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
sbb ecx, dword [0]
cmp ecx, SubRes32
jnz fail
inc dx
%line 284+1 alu.asm
mov bx, 0xAAAA
%line 284+0 alu.asm
mov si, 0x5555
clc

db 0x18 | 0x01




db 0xDE
cmp si, SubRes16
jnz fail
inc dx
%line 285+1 alu.asm
mov bx, 0x5555
%line 285+0 alu.asm
mov si, 0xAAAA
clc

db 0x18 | 0x03




db 0xDE
cmp bx, SubRes16
jnz fail
inc dx
%line 286+1 alu.asm
mov ebx, 0xAAAAAAAA
%line 286+0 alu.asm
mov esi, 0x55555555
clc

db 0x66

db 0x18 | 0x01




db 0xDE
cmp esi, SubRes32
jnz fail
inc dx
%line 287+1 alu.asm
mov ebx, 0x55555555
%line 287+0 alu.asm
mov esi, 0xAAAAAAAA
clc

db 0x66

db 0x18 | 0x03




db 0xDE
cmp ebx, SubRes32
jnz fail
inc dx
%line 288+1 alu.asm

mov al, 0x55
%line 289+0 alu.asm

sbb al, 0xAA
cmp al, SubRes8
jnz fail
inc dx
%line 290+1 alu.asm
mov ax, 0x5555
%line 290+0 alu.asm
sbb ax, 0xAAAA
cmp ax, SubRes16
jnz fail
inc dx
%line 291+1 alu.asm
mov eax, 0x55555555
%line 291+0 alu.asm
sbb eax, 0xAAAAAAAA
cmp eax, SubRes32
jnz fail
inc dx
%line 292+1 alu.asm
inc dx

AndRes8 equ (0x55&0xAA)&0xFF
AndRes16 equ (0x5555&0xAAAA)&0xFFFF
AndRes32 equ (0x55555555&0xAAAAAAAA)&0xFFFFFFFF

mov byte [0], 0x55
%line 298+0 alu.asm
mov ch, 0xAA
clc
and byte [0], ch
cmp byte [0], AndRes8
jnz fail
inc dx
%line 299+1 alu.asm
mov ch, 0x55
%line 299+0 alu.asm
mov byte [0], 0xAA
clc
and ch, byte [0]
cmp ch, AndRes8
jnz fail
inc dx
%line 300+1 alu.asm
mov bl, 0xAA
%line 300+0 alu.asm
mov dh, 0x55
clc

db 0x20




db 0xDE
cmp dh, AndRes8
jnz fail
inc dx
%line 301+1 alu.asm
mov bl, 0x55
%line 301+0 alu.asm
mov dh, 0xAA
clc

db 0x20 | 0x02




db 0xDE
cmp bl, AndRes8
jnz fail
inc dx
%line 302+1 alu.asm

mov word [0], 0x5555
%line 303+0 alu.asm
mov cx, 0xAAAA
clc
and word [0], cx
cmp word [0], AndRes16
jnz fail
inc dx
%line 304+1 alu.asm
mov cx, 0x5555
%line 304+0 alu.asm
mov word [0], 0xAAAA
clc
and cx, word [0]
cmp cx, AndRes16
jnz fail
inc dx
%line 305+1 alu.asm
mov dword [0], 0x55555555
%line 305+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
and dword [0], ecx
cmp dword [0], AndRes32
jnz fail
inc dx
%line 306+1 alu.asm
mov ecx, 0x55555555
%line 306+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
and ecx, dword [0]
cmp ecx, AndRes32
jnz fail
inc dx
%line 307+1 alu.asm
mov bx, 0xAAAA
%line 307+0 alu.asm
mov si, 0x5555
clc

db 0x20 | 0x01




db 0xDE
cmp si, AndRes16
jnz fail
inc dx
%line 308+1 alu.asm
mov bx, 0x5555
%line 308+0 alu.asm
mov si, 0xAAAA
clc

db 0x20 | 0x03




db 0xDE
cmp bx, AndRes16
jnz fail
inc dx
%line 309+1 alu.asm
mov ebx, 0xAAAAAAAA
%line 309+0 alu.asm
mov esi, 0x55555555
clc

db 0x66

db 0x20 | 0x01




db 0xDE
cmp esi, AndRes32
jnz fail
inc dx
%line 310+1 alu.asm
mov ebx, 0x55555555
%line 310+0 alu.asm
mov esi, 0xAAAAAAAA
clc

db 0x66

db 0x20 | 0x03




db 0xDE
cmp ebx, AndRes32
jnz fail
inc dx
%line 311+1 alu.asm

mov al, 0x55
%line 312+0 alu.asm

and al, 0xAA
cmp al, AndRes8
jnz fail
inc dx
%line 313+1 alu.asm
mov ax, 0x5555
%line 313+0 alu.asm
and ax, 0xAAAA
cmp ax, AndRes16
jnz fail
inc dx
%line 314+1 alu.asm
mov eax, 0x55555555
%line 314+0 alu.asm
and eax, 0xAAAAAAAA
cmp eax, AndRes32
jnz fail
inc dx
%line 315+1 alu.asm
inc dx

mov byte [0], 0x55
%line 317+0 alu.asm
mov ch, 0xAA
clc
sub byte [0], ch
cmp byte [0], SubRes8
jnz fail
inc dx
%line 318+1 alu.asm
mov ch, 0x55
%line 318+0 alu.asm
mov byte [0], 0xAA
clc
sub ch, byte [0]
cmp ch, SubRes8
jnz fail
inc dx
%line 319+1 alu.asm
mov bl, 0xAA
%line 319+0 alu.asm
mov dh, 0x55
clc

db 0x28




db 0xDE
cmp dh, SubRes8
jnz fail
inc dx
%line 320+1 alu.asm
mov bl, 0x55
%line 320+0 alu.asm
mov dh, 0xAA
clc

db 0x28 | 0x02




db 0xDE
cmp bl, SubRes8
jnz fail
inc dx
%line 321+1 alu.asm

mov word [0], 0x5555
%line 322+0 alu.asm
mov cx, 0xAAAA
clc
sub word [0], cx
cmp word [0], SubRes16
jnz fail
inc dx
%line 323+1 alu.asm
mov cx, 0x5555
%line 323+0 alu.asm
mov word [0], 0xAAAA
clc
sub cx, word [0]
cmp cx, SubRes16
jnz fail
inc dx
%line 324+1 alu.asm
mov dword [0], 0x55555555
%line 324+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
sub dword [0], ecx
cmp dword [0], SubRes32
jnz fail
inc dx
%line 325+1 alu.asm
mov ecx, 0x55555555
%line 325+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
sub ecx, dword [0]
cmp ecx, SubRes32
jnz fail
inc dx
%line 326+1 alu.asm
mov bx, 0xAAAA
%line 326+0 alu.asm
mov si, 0x5555
clc

db 0x28 | 0x01




db 0xDE
cmp si, SubRes16
jnz fail
inc dx
%line 327+1 alu.asm
mov bx, 0x5555
%line 327+0 alu.asm
mov si, 0xAAAA
clc

db 0x28 | 0x03




db 0xDE
cmp bx, SubRes16
jnz fail
inc dx
%line 328+1 alu.asm
mov ebx, 0xAAAAAAAA
%line 328+0 alu.asm
mov esi, 0x55555555
clc

db 0x66

db 0x28 | 0x01




db 0xDE
cmp esi, SubRes32
jnz fail
inc dx
%line 329+1 alu.asm
mov ebx, 0x55555555
%line 329+0 alu.asm
mov esi, 0xAAAAAAAA
clc

db 0x66

db 0x28 | 0x03




db 0xDE
cmp ebx, SubRes32
jnz fail
inc dx
%line 330+1 alu.asm

mov al, 0x55
%line 331+0 alu.asm

sub al, 0xAA
cmp al, SubRes8
jnz fail
inc dx
%line 332+1 alu.asm
mov ax, 0x5555
%line 332+0 alu.asm
sub ax, 0xAAAA
cmp ax, SubRes16
jnz fail
inc dx
%line 333+1 alu.asm
mov eax, 0x55555555
%line 333+0 alu.asm
sub eax, 0xAAAAAAAA
cmp eax, SubRes32
jnz fail
inc dx
%line 334+1 alu.asm
inc dx

XorRes8 equ (0x55^0xAA)&0xFF
XorRes16 equ (0x5555^0xAAAA)&0xFFFF
XorRes32 equ (0x55555555^0xAAAAAAAA)&0xFFFFFFFF

mov byte [0], 0x55
%line 340+0 alu.asm
mov ch, 0xAA
clc
xor byte [0], ch
cmp byte [0], XorRes8
jnz fail
inc dx
%line 341+1 alu.asm
mov ch, 0x55
%line 341+0 alu.asm
mov byte [0], 0xAA
clc
xor ch, byte [0]
cmp ch, XorRes8
jnz fail
inc dx
%line 342+1 alu.asm
mov bl, 0xAA
%line 342+0 alu.asm
mov dh, 0x55
clc

db 0x30




db 0xDE
cmp dh, XorRes8
jnz fail
inc dx
%line 343+1 alu.asm
mov bl, 0x55
%line 343+0 alu.asm
mov dh, 0xAA
clc

db 0x30 | 0x02




db 0xDE
cmp bl, XorRes8
jnz fail
inc dx
%line 344+1 alu.asm

mov word [0], 0x5555
%line 345+0 alu.asm
mov cx, 0xAAAA
clc
xor word [0], cx
cmp word [0], XorRes16
jnz fail
inc dx
%line 346+1 alu.asm
mov cx, 0x5555
%line 346+0 alu.asm
mov word [0], 0xAAAA
clc
xor cx, word [0]
cmp cx, XorRes16
jnz fail
inc dx
%line 347+1 alu.asm
mov dword [0], 0x55555555
%line 347+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
xor dword [0], ecx
cmp dword [0], XorRes32
jnz fail
inc dx
%line 348+1 alu.asm
mov ecx, 0x55555555
%line 348+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
xor ecx, dword [0]
cmp ecx, XorRes32
jnz fail
inc dx
%line 349+1 alu.asm
mov bx, 0xAAAA
%line 349+0 alu.asm
mov si, 0x5555
clc

db 0x30 | 0x01




db 0xDE
cmp si, XorRes16
jnz fail
inc dx
%line 350+1 alu.asm
mov bx, 0x5555
%line 350+0 alu.asm
mov si, 0xAAAA
clc

db 0x30 | 0x03




db 0xDE
cmp bx, XorRes16
jnz fail
inc dx
%line 351+1 alu.asm
mov ebx, 0xAAAAAAAA
%line 351+0 alu.asm
mov esi, 0x55555555
clc

db 0x66

db 0x30 | 0x01




db 0xDE
cmp esi, XorRes32
jnz fail
inc dx
%line 352+1 alu.asm
mov ebx, 0x55555555
%line 352+0 alu.asm
mov esi, 0xAAAAAAAA
clc

db 0x66

db 0x30 | 0x03




db 0xDE
cmp ebx, XorRes32
jnz fail
inc dx
%line 353+1 alu.asm

mov al, 0x55
%line 354+0 alu.asm

xor al, 0xAA
cmp al, XorRes8
jnz fail
inc dx
%line 355+1 alu.asm
mov ax, 0x5555
%line 355+0 alu.asm
xor ax, 0xAAAA
cmp ax, XorRes16
jnz fail
inc dx
%line 356+1 alu.asm
mov eax, 0x55555555
%line 356+0 alu.asm
xor eax, 0xAAAAAAAA
cmp eax, XorRes32
jnz fail
inc dx
%line 357+1 alu.asm
inc dx

CmpRes8 equ 0x55
CmpRes16 equ 0x5555
CmpRes32 equ 0x55555555

mov byte [0], 0x55
%line 363+0 alu.asm
mov ch, 0xAA
clc
cmp byte [0], ch
cmp byte [0], CmpRes8
jnz fail
inc dx
%line 364+1 alu.asm
mov ch, 0x55
%line 364+0 alu.asm
mov byte [0], 0xAA
clc
cmp ch, byte [0]
cmp ch, CmpRes8
jnz fail
inc dx
%line 365+1 alu.asm
mov bl, 0xAA
%line 365+0 alu.asm
mov dh, 0x55
clc

db 0x38




db 0xDE
cmp dh, CmpRes8
jnz fail
inc dx
%line 366+1 alu.asm
mov bl, 0x55
%line 366+0 alu.asm
mov dh, 0xAA
clc

db 0x38 | 0x02




db 0xDE
cmp bl, CmpRes8
jnz fail
inc dx
%line 367+1 alu.asm

mov word [0], 0x5555
%line 368+0 alu.asm
mov cx, 0xAAAA
clc
cmp word [0], cx
cmp word [0], CmpRes16
jnz fail
inc dx
%line 369+1 alu.asm
mov cx, 0x5555
%line 369+0 alu.asm
mov word [0], 0xAAAA
clc
cmp cx, word [0]
cmp cx, CmpRes16
jnz fail
inc dx
%line 370+1 alu.asm
mov dword [0], 0x55555555
%line 370+0 alu.asm
mov ecx, 0xAAAAAAAA
clc
cmp dword [0], ecx
cmp dword [0], CmpRes32
jnz fail
inc dx
%line 371+1 alu.asm
mov ecx, 0x55555555
%line 371+0 alu.asm
mov dword [0], 0xAAAAAAAA
clc
cmp ecx, dword [0]
cmp ecx, CmpRes32
jnz fail
inc dx
%line 372+1 alu.asm
mov bx, 0xAAAA
%line 372+0 alu.asm
mov si, 0x5555
clc

db 0x38 | 0x01




db 0xDE
cmp si, CmpRes16
jnz fail
inc dx
%line 373+1 alu.asm
mov bx, 0x5555
%line 373+0 alu.asm
mov si, 0xAAAA
clc

db 0x38 | 0x03




db 0xDE
cmp bx, CmpRes16
jnz fail
inc dx
%line 374+1 alu.asm
mov ebx, 0xAAAAAAAA
%line 374+0 alu.asm
mov esi, 0x55555555
clc

db 0x66

db 0x38 | 0x01




db 0xDE
cmp esi, CmpRes32
jnz fail
inc dx
%line 375+1 alu.asm
mov ebx, 0x55555555
%line 375+0 alu.asm
mov esi, 0xAAAAAAAA
clc

db 0x66

db 0x38 | 0x03




db 0xDE
cmp ebx, CmpRes32
jnz fail
inc dx
%line 376+1 alu.asm

mov al, 0x55
%line 377+0 alu.asm

cmp al, 0xAA
cmp al, CmpRes8
jnz fail
inc dx
%line 378+1 alu.asm
mov ax, 0x5555
%line 378+0 alu.asm
cmp ax, 0xAAAA
cmp ax, CmpRes16
jnz fail
inc dx
%line 379+1 alu.asm
mov eax, 0x55555555
%line 379+0 alu.asm
cmp eax, 0xAAAAAAAA
cmp eax, CmpRes32
jnz fail
inc dx
%line 380+1 alu.asm
inc dx
pop ds

jmp begintest

failstr: db 'alu 0x$2 failed', 0
fail:

 pop ds
 mov si, failstr
 push dx
 push word 0
 call printstr
 cli
 hlt


print_nc8_16:
 push dx
 push word 0
 push ax
 push word 0
 push cx
 push word 0
 push bx
 push word 0
 call printstr
 add sp, 4 * 4
 ret

print_c8_16:
 push dx
 push word 0
 push ax
 push word 0
 push cx
 push word 0
 push bx
 push bp
 push word 0
 call printstr
 add sp, 5 * 4
 ret

begintest:


%line 430+1 alu.asm

%line 433+1 alu.asm

%line 436+1 alu.asm

%line 1+1 testalu.asm

%line 6+1 testalu.asm

add8:
 xor bx, bx
 xor di, di


 xor eax, eax
 xor ecx, ecx

 mov si, .str
 jmp .optest
.str: db "add8 $2+$2=$2 fl=$4", 0
.optest:

 mov al, [testcase8_op1 + bx]
 mov cl, [testcase8_op2 + di]
 mov bl, al

 add al, cl


 pushfw
%line 27+0 testalu.asm
 pop word dx
%line 32+1 testalu.asm
 call print_nc8_16


%line 43+1 testalu.asm
 add bx, 4
 cmp bx, (8 * 4)
 jnz .optest


 xor bx, bx
 add di, 4
 cmp di, (8 * 4)
 jnz .optest

%line 56+1 testalu.asm

%line 441+1 alu.asm

%line 1+1 testalu.asm

%line 6+1 testalu.asm

or8:
 xor bx, bx
 xor di, di


 xor eax, eax
 xor ecx, ecx

 mov si, .str
 jmp .optest
.str: db "or8 $2|$2=$2 fl=$4", 0
.optest:

 mov al, [testcase8_op1 + bx]
 mov cl, [testcase8_op2 + di]
 mov bl, al

 or al, cl


 pushfw
%line 27+0 testalu.asm
 pop word dx
%line 32+1 testalu.asm
 call print_nc8_16


%line 43+1 testalu.asm
 add bx, 4
 cmp bx, (8 * 4)
 jnz .optest


 xor bx, bx
 add di, 4
 cmp di, (8 * 4)
 jnz .optest

%line 56+1 testalu.asm

%line 446+1 alu.asm

%line 1+1 testalu.asm

%line 6+1 testalu.asm

adc8:
 xor bx, bx
 xor di, di


 xor eax, eax
 xor ecx, ecx

 mov si, .str
 jmp .optest
.str: db "adc8 $1+$2+$2=$2 fl=$4", 0
.optest:

 mov al, [testcase8_op1 + bx]
 mov cl, [testcase8_op2 + di]
 mov bl, al

 adc al, cl


 pushfw
%line 27+0 testalu.asm
 pop word dx
%line 29+1 testalu.asm
 xor bp, bp
 call print_c8_16
%line 34+1 testalu.asm


 stc
 mov bl, al
 adc al, cl
 pushfw
%line 39+0 testalu.asm
 pop word dx
%line 40+1 testalu.asm
 inc bp
 call print_c8_16

 add bx, 4
 cmp bx, (8 * 4)
 jnz .optest


 xor bx, bx
 add di, 4
 cmp di, (8 * 4)
 jnz .optest

%line 56+1 testalu.asm

%line 452+1 alu.asm

%line 1+1 testalu.asm

%line 6+1 testalu.asm

sbb8:
 xor bx, bx
 xor di, di


 xor eax, eax
 xor ecx, ecx

 mov si, .str
 jmp .optest
.str: db "sbb8 -$1+$2-$2=$2 fl=$4", 0
.optest:

 mov al, [testcase8_op1 + bx]
 mov cl, [testcase8_op2 + di]
 mov bl, al

 sbb al, cl


 pushfw
%line 27+0 testalu.asm
 pop word dx
%line 29+1 testalu.asm
 xor bp, bp
 call print_c8_16
%line 34+1 testalu.asm


 stc
 mov bl, al
 sbb al, cl
 pushfw
%line 39+0 testalu.asm
 pop word dx
%line 40+1 testalu.asm
 inc bp
 call print_c8_16

 add bx, 4
 cmp bx, (8 * 4)
 jnz .optest


 xor bx, bx
 add di, 4
 cmp di, (8 * 4)
 jnz .optest

%line 56+1 testalu.asm

%line 457+1 alu.asm

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
