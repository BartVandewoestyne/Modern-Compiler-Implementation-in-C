CFLAGS = -std=c90 -g -Wall -Wextra
CC = gcc

all: test_maxargs test_interp test_persistent_tree test_persistent_binding_tree

test_maxargs: test_maxargs.o prog1.o slp.o util.o maxargs.o
	$(CC) $(CFLAGS) -o test_maxargs test_maxargs.o prog1.o slp.o util.o maxargs.o

test_interp: test_interp.o prog1.o slp.o util.o interp.o
	$(CC) $(CFLAGS) -o test_interp test_interp.o prog1.o slp.o util.o interp.o

test_persistent_tree: test_persistent_tree.o util.o persistent_tree.o
	$(CC) $(CFLAGS) -o test_persistent_tree test_persistent_tree.o util.o persistent_tree.o

test_persistent_binding_tree: test_persistent_binding_tree.o util.o persistent_binding_tree.o
	$(CC) $(CFLAGS) -o test_persistent_binding_tree test_persistent_binding_tree.o util.o persistent_binding_tree.o

test_maxargs.o: test_maxargs.c slp.h util.h maxargs.h
	$(CC) $(CFLAGS) -c test_maxargs.c

test_interp.o: test_interp.c slp.h util.h interp.h
	$(CC) $(CFLAGS) -c test_interp.c

test_persistent_tree.o: test_persistent_tree.c persistent_tree.h
	$(CC) $(CFLAGS) -c test_persistent_tree.c

test_persistent_binding_tree.o: test_persistent_binding_tree.c persistent_binding_tree.h
	$(CC) $(CFLAGS) -c test_persistent_binding_tree.c

prog1.o: prog1.c slp.h util.h
	$(CC) $(CFLAGS) -c prog1.c

slp.o: slp.c slp.h util.h
	$(CC) $(CFLAGS) -c slp.c

maxargs.o: maxargs.c maxargs.h slp.h
	$(CC) $(CFLAGS) -c maxargs.c

interp.o: interp.c interp.h slp.h util.h
	$(CC) $(CFLAGS) -c interp.c

persistent_tree.o: persistent_tree.c persistent_tree.h util.h
	$(CC) $(CFLAGS) -c persistent_tree.c

persistent_binding_tree.o: persistent_binding_tree.c persistent_binding_tree.h util.h
	$(CC) $(CFLAGS) -c persistent_binding_tree.c

util.o: util.c util.h
	$(CC) $(CFLAGS) -c util.c

.PHONY: clean
clean: 
	rm -f a.out *.o \
	test_maxargs test_interp test_persistent_tree test_persistent_binding_tree
