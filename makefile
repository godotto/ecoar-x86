CC = gcc	# GCC as C compiler and linker
ASM = nasm	# Netwide Assembler as x86 assembler

SRCDIR = src
BUILDDIR = build
EXE = firstconst
TARGET = bin/$(EXE)


ASMFLAGS = -f elf32 -l $(BUILDDIR)/firstconst.lst -g -F dwarf
CFLAGS = -m32 -c -g -O0
LINKFLAGS = -m32 -g -o $(TARGET)

all: assemble compile link

asm_link:
	assemble link

assemble:
	$(ASM) $(ASMFLAGS) $(SRCDIR)/firstconst.s -o $(BUILDDIR)/$(EXE).o

compile:
	$(CC) $(CFLAGS) $(SRCDIR)/main.c  -o $(BUILDDIR)/main.o

link:
	$(CC) $(LINKFLAGS) $(BUILDDIR)/main.o $(BUILDDIR)/firstconst.o

clean:
	rm $(BUILDDIR)/*.o
	rm $(BUILDDIR)/*.lst