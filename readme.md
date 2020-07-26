# x86 cpu verification test

`verr` is an x86 CPU verification test. It is also [the name of an instruction](https://www.felixcloutier.com/x86/verr:verw). It was written for the [Halfix x86 emulator](https://github.com/nepx/halfix), but I hope that other x86 emulation projects will find this useful. 

## How to use 

ROMs can take the place of regular BIOS ROMs, with the caveat that they won't be capable of booting any operating systems. The CPU should start in real mode, with CS:IP set to `0xF000:0xFFF0`. Each ROM is 128k long, so it should be loaded at offset `0xE0000`. The minimum supported processor is a 80386. 

The result of every operation will be logged through `0x402`, the Bochs BIOS output port. You can redirect this output to a file or device of your own choosing. 

## How to build

```bash
 $ node makefile.js
```

Make sure that you have `nasm` installed. To verify ALU output, a C compiler -- `gcc` or `clang` -- is necessary. 

## Opcodes Tested 

 - `src/tests/alu`: `00-3F`, all forms (not including segment pushes/pops). `C0-C1`, all forms. `D1-D3`, all forms. 