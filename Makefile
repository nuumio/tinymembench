all: tinymembench

ifdef WINDIR
	CC = gcc
endif

MINREPEATS ?= 3
MAXREPEATS ?= 10
LATBENCH_REPEATS ?= 10
LATBENCH_COUNT ?= 10000000
MEM_REALLOC ?= 0

tinymembench: main.c util.o util.h asm-opt.h version.h asm-opt.o x86-sse2.o arm-neon.o mips-32.o aarch64-asm.o
	${CC} -O2 ${CFLAGS} "-DCFLAGS=\"${CFLAGS}\"" \
		-DMINREPEATS=${MINREPEATS} \
		-DMAXREPEATS=${MAXREPEATS} \
		-DLATBENCH_REPEATS=${LATBENCH_REPEATS} \
		-DLATBENCH_COUNT=${LATBENCH_COUNT} \
		-DMEM_REALLOC=${MEM_REALLOC} \
		-o tinymembench main.c util.o asm-opt.o x86-sse2.o arm-neon.o mips-32.o aarch64-asm.o -lm

util.o: util.c util.h
	${CC} -O2 ${CFLAGS} -c util.c

asm-opt.o: asm-opt.c asm-opt.h x86-sse2.h arm-neon.h mips-32.h
	${CC} -O2 ${CFLAGS} -c asm-opt.c

x86-sse2.o: x86-sse2.S
	${CC} -O2 ${CFLAGS} -c x86-sse2.S

arm-neon.o: arm-neon.S
	${CC} -O2 ${CFLAGS} -c arm-neon.S

aarch64-asm.o: aarch64-asm.S
	${CC} -O2 ${CFLAGS} -c aarch64-asm.S

mips-32.o: mips-32.S
	${CC} -O2 ${CFLAGS} -c mips-32.S

clean:
	-rm -f tinymembench
	-rm -f tinymembench.exe
	-rm -f *.o
