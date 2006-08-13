
OBJ=bib2olac.o xml.o
LIB=/usr/local/lib/libbtparse.a

CC=gcc
CFLAGS=-g

EXEC=bib2olac

bib2olac:	$(OBJ) $(LIB)
			$(CC) $(CFLAGS) -o $(EXEC) $(OBJ) $(LIB)

clean:
			/bin/rm -f $(OBJ)

depend:
	sed -n -e '1,/^#--- OBJECT FILE DEPENDENCIES/p' Makefile > Makefile.new
	gcc -MM *.c >> Makefile.new
	mv Makefile.new Makefile

#--- OBJECT FILE DEPENDENCIES
bib2olac.o: bib2olac.c olac.h xml.h
xml.o: xml.c xml.h
