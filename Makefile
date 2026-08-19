CC      = cc
AS      = as
CFLAGS  = -ffreestanding -fno-builtin -Wall -Wextra
TARGET  = hello

.PHONY: all run clean

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
