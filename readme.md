# verr: x86 emulator accuracy test

`verr` is a set of small assembly language programs to test x86 emulators. [It's also the name of an instruction](https://www.felixcloutier.com/x86/verr:verw). The tests are based on the official [RISC-V test suite](https://github.com/riscv/riscv-tests), though there are a number of differences. 

## Test Layout

Each test is a small self-checking binary file and must be executed in a specific environment called a Test Virtual Machine (TVM). A TVM is an artificially-created environment for a test to run in; look in the various `src/` directories to find out what registers and fields that you have to populate. Those left unspecified do not have to be modified; if a TVM does not specify the initial value of `CR2`, for instance, then the register will either not be touched or be written before it is read. 

Because the tests check themselves, the values of the registers or memory do not need to be inspected afterwards. However, this means that instructions that check the results must perform correctly. The CPU emulator can be reused between tests, as long as its fields are reinitialized back to zero, and memory does not need to be cleared. 

A byte will be written to port `0x1234` on completion. Zero indicates that the test was successful; other values indicate that something went wrong. Look up the individual test to figure out why. Aside from performance tests, if a test runs more than a few million instructions, it has likely failed. Triple faults always indicate a failure. 

## "This test didn't catch *that* bug!"

Of course, since this is the work of one individual, there are sure to be instructions or edge cases that fall between the cracks. Pull requests and issues are gladly accepted. 

