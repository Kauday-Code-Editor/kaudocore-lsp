CC = cc
CFLAGS = -O2 -Wall -Wextra -pedantic
LDFLAGS =
TARGET = c-lsp

all: $(TARGET)

$(TARGET): main.c
	$(CC) $(CFLAGS) -o $(TARGET) main.c $(LDFLAGS)

clean:
	rm -f $(TARGET)
