# We cannot use the -std=c90 flag here, because the book's code uses the
# strdup function, so it seems like its written in another C-dialect...
CFLAGS = -g -Wall -Wextra
CC = gcc

lextest: driver.o lex.yy.o errormsg.o util.o
	$(CC) $(CFLAGS) -o lextest driver.o lex.yy.o errormsg.o util.o

driver.o: driver.c tokens.h errormsg.h util.h
	$(CC) $(CFLAGS) -c driver.c

errormsg.o: errormsg.c errormsg.h util.h
	$(CC) $(CFLAGS) -c errormsg.c

lex.yy.o: lex.yy.c tokens.h errormsg.h util.h
	$(CC) $(CFLAGS) -c lex.yy.c

lex.yy.c: tiger.lex
	lex tiger.lex

util.o: util.c util.h
	$(CC) $(CFLAGS) -c util.c

clean: 
	rm -f lextest *.o lex.yy.c
