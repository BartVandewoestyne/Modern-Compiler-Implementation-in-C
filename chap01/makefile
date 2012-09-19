all: test_maxargs test_interp

test_maxargs: test_maxargs.o prog1.o slp.o util.o maxargs.o
	cc -g -Wall -o test_maxargs test_maxargs.o prog1.o slp.o util.o maxargs.o

test_interp: test_interp.o prog1.o slp.o util.o interp.o
	cc -g -Wall -o test_interp test_interp.o prog1.o slp.o util.o interp.o

test_maxargs.o: test_maxargs.c slp.h util.h maxargs.h
	cc -g -Wall -c test_maxargs.c

test_interp.o: test_interp.c slp.h util.h interp.h
	cc -g -Wall -c test_interp.c

prog1.o: prog1.c slp.h util.h
	cc -g -Wall -c prog1.c

slp.o: slp.c slp.h util.h
	cc -g -Wall -c slp.c

maxargs.o: maxargs.c maxargs.h slp.h
	cc -g -Wall -c maxargs.c

interp.o: interp.c interp.h slp.h util.h
	cc -g -Wall -c interp.c

util.o: util.c util.h
	cc -g -Wall -c util.c

clean: 
	rm -f a.out test_maxargs test_interp util.o prog1.o slp.o maxargs.o interp.o test_maxargs.o test_interp.o
