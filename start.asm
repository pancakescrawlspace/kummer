// start.asm - arm64 macOS entry point and raw syscall wrappers.
//
// macOS does not provide a way to run without dyld/libSystem in newer
// releases, so we still link against libSystem, but we never call any
// of its functions -- every syscall below is issued directly with the
// "svc #0x80" instruction, bypassing the C standard library entirely.
//
// arm64 Darwin syscall ABI: syscall number in x16, arguments in
// x0-x7, "svc #0x80" traps into the kernel, result comes back in x0.

    .section __TEXT,__text
    .globl _start
    .align 2
_start:
    // Stack must be 16-byte aligned before calling into C.
    bl      _main
    // main()'s return value is already in w0; use it as the exit code.
    mov     x16, #1         // SYS_exit
    svc     #0x80

// long sys_write(int fd, const void *buf, unsigned long count);
    .globl _sys_write
    .align 2
_sys_write:
    mov     x16, #4         // SYS_write
    svc     #0x80
    ret

// void sys_exit(int code);
    .globl _sys_exit
    .align 2
_sys_exit:
    mov     x16, #1         // SYS_exit
    svc     #0x80
    ret                     // unreachable
