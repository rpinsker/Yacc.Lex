CFLAGS= -std=c99

para: tokens.o para.o

tokens.o: tokens.c para.h

tokens.c: tokens.l
	flex -o tokens.c tokens.l

para.c para.h: parse.y
	bison -d parse.y -o para.c