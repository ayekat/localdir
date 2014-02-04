CC?=gcc
SRC=xor.c
CFLAGS=-Wall -Wpedantic -std=c99
NAME=xor
INSTALLDIR=~/.local

build: $(SRC)
	$(CC) ${CFLAGS} ${SRC} -o ${NAME}

install:
	install ${NAME} ${INSTALLDIR}/bin/${NAME}

uninstall:
	rm ${INSTALLDIR}/bin/${NAME}
