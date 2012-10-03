CFLAGS = -g -Wall -Wextra
CC = gcc

a.out: parsetest.o y.tab.o lex.yy.o errormsg.o util.o
	$(CC) $(CFLAGS) parsetest.o y.tab.o lex.yy.o errormsg.o util.o

parsetest.o: parsetest.c errormsg.h util.h
	$(CC) $(CFLAGS) -c parsetest.c

y.tab.o: y.tab.c
	$(CC) $(CFLAGS) -c y.tab.c

y.tab.c: tiger.grm
	yacc -dv tiger.grm

y.tab.h: y.tab.c
	echo "y.tab.h was created at the same time as y.tab.c"

errormsg.o: errormsg.c errormsg.h util.h
	$(CC) $(CFLAGS) -c errormsg.c

lex.yy.o: lex.yy.c y.tab.h errormsg.h util.h
	$(CC) $(CFLAGS) -c lex.yy.c

lex.yy.c: tiger.lex
	lex tiger.lex

util.o: util.c util.h
	$(CC) $(CFLAGS) -c util.c

clean: 
	rm -f a.out util.o parsetest.o lex.yy.o errormsg.o lex.yy.c y.tab.c y.tab.h y.tab.o
