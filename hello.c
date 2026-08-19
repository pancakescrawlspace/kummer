/* hello.c - freestanding C, no standard library.
 *
 * sys_write/sys_exit are raw syscall wrappers implemented in start.asm;
 * no libc headers or functions are used here.
 */

extern long sys_write(int fd, const void *buf, unsigned long count);
extern void sys_exit(int code);

static unsigned long my_strlen(const char *s) {
    unsigned long len = 0;
    while (s[len]) {
        len++;
    }
    return len;
}

int main(void) {
    const char *msg = "Hello world!\n";
    sys_write(1, msg, my_strlen(msg));
    sys_exit(0);
    return 0; /* unreachable */
}
