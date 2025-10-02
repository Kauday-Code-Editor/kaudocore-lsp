ASM = nasm
LD = ld
ASMFLAGS = -f elf64
LDFLAGS =
TARGET = asm-lsp

all: $(TARGET)

$(TARGET): main.o
	$(LD) -o $(TARGET) main.o $(LDFLAGS)

main.o: main.asm
	$(ASM) $(ASMFLAGS) -o main.o main.asm

clean:
	rm -f $(TARGET) main.o
