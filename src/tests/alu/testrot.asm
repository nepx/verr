; if we were too lazy to definte OP2, then define them here
%ifndef OP2
%define OP2 vcx 
%define OP2_DEF1
%endif

TESTID:
    xor bx, bx
    xor di, di

    ; Clear entire registers, including upper 16 bits.
    xor eax, eax
    xor ecx, ecx

    mov si, .str
    jmp .optest
.str: db TESTSTR, 0
.optest:
    push bx
    clc
    mov vax, [TESTCASE_TBL_OP1 + bx]
    mov cl, [TESTCASE_TBL_OP2 + di]
    mov vbx, vax

    TESTINSN vax, cl

    ; Get flags
    getflags dx 

    ; ROR only modifies the CF/OF flags
    and dx, 0x801
    push cx
    and cl, 31 ; xxx -- correct? (no modulo?)
    
    cmp cl, 1
    jz .done1

    ; OF is undefined for 8-bit shifts
    and dx, ~0x800

.done1:
    pop cx
%ifdef CARRY_TEST
    xor bp, bp
    call print_c
%else
    call print_nc
%endif 

%ifdef CARRY_TEST
    stc
    mov vax, vbx
    TESTINSN vax, cl
    getflags dx

    and dx, 0x801
    push cx
    and cl, 31 ; xxx -- correct? (no modulo?)
    cmp cl, 1
    jz .done2
    and dx, ~0x800

.done2:
    pop cx
    inc bp
    call print_c
%endif
    pop bx
    add bx, 4
    cmp bx, TESTCASES
    jnz .optest

    ; Clear eBX and restart
    xor bx, bx
    add di, 4
    cmp di, TESTCASES
    jnz .optest

%undef TESTID 
%undef TESTSTR
%undef TESTINSN

%ifdef OP2_DEF1
%undef OP2_DEF1
%undef OP2
%endif