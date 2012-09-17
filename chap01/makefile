test_maxargs: test_maxargs.o prog1.o slp.o util.o maxargs.o
	cc -g -o test_maxargs test_maxargs.o prog1.o slp.o util.o maxargs.o

test_maxargs.o: test_maxargs.c slp.h util.h maxargs.h
	cc -g -c test_maxargs.c

prog1.o: prog1.c slp.h util.h
	cc -g -c prog1.c

slp.o: slp.c slp.h util.h
	cc -g -c slp.c

maxargs.o: maxargs.c maxargs.h slp.h
	cc -g -c maxargs.c

util.o: util.c util.h
	cc -g -c util.c

clean: 
	rm -f a.out test_maxargs util.o prog1.o slp.o maxargs.o test_maxargs.o
