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
    mov vcx, [TESTCASE_TBL_OP2 + di]
    mov vbx, vax

    TESTINSN vax, vcx

    ; Get flags
    getflags dx 
%ifdef CARRY_TEST
    xor bp, bp
    call print_c
%else
    call print_nc
%endif 

%ifdef CARRY_TEST
    stc
    mov vbx, vax
    TESTINSN vax, vcx
    getflags dx
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