CC      = cc
AS      = as
CFLAGS  = -ffreestanding -fno-builtin -Wall -Wextra
TARGET  = hello

COMPOSE = docker compose -f linux/docker-compose.yml run --rm build

.PHONY: all run clean linux linux-run linux-clean

all: $(TARGET)

$(TARGET): start.o hello.o
	$(CC) -e _start -o $@ start.o hello.o

start.o: start.asm
	$(AS) -o $@ start.asm

hello.o: hello.c
	$(CC) $(CFLAGS) -c -o $@ hello.c

run: $(TARGET)
	./$(TARGET)

clean:
	rm -f start.o hello.o $(TARGET)

# Build/run the Linux port (linux/) inside the container defined by
# linux/Dockerfile + linux/docker-compose.yml, since this is a macOS
# machine and the code targets ELF/Linux syscalls.
linux:
	$(COMPOSE) bash -c "make"

linux-run:
	$(COMPOSE) bash -c "make && ./hello"

linux-clean:
	rm -f linux/start.o linux/hello.o linux/hello
