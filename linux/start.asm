// start.asm - Linux arm64 entry point and raw syscall wrappers.
//
// Built for a standard ELF/Linux toolchain (e.g. debian:trixie-slim), as
// opposed to the Mach-O/Darwin version in ../start.asm. No libc startup
// code is used -- every syscall below is issued directly with the
// "svc #0" instruction, bypassing the C standard library entirely.
//
// arm64 Linux syscall ABI: syscall number in x8, arguments in x0-x5,
// "svc #0" traps into the kernel, result comes back in x0.
//
// Note: unlike Darwin, ELF/Linux does not prefix C symbols with an
// underscore, so these labels are "_start"/"main"/"sys_write" rather
// than "_start"/"_main"/"_sys_write".

    .section .text
    .globl _start
    .align 2
_start:
    // Stack must be 16-byte aligned before calling into C.
    bl      main
    // main()'s return value is already in w0; use it as the exit code.
    mov     x8, #93         // SYS_exit
    svc     #0

// long sys_write(int fd, const void *buf, unsigned long count);
    .globl sys_write
    .align 2
sys_write:
    mov     x8, #64         // SYS_write
    svc     #0
    ret

// void sys_exit(int code);
    .globl sys_exit
    .align 2
sys_exit:
    mov     x8, #93         // SYS_exit
    svc     #0
    ret                     // unreachable
