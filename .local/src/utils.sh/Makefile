-include config.mk

INSTALLDIR ?= /usr/local
INCLUDEDIR ?= ${INSTALLDIR}/include

all: # nothing to be done

install:
	mkdir -p ${INCLUDEDIR}
	install -m 644 utils.sh ${INCLUDEDIR}/

uninstall:
	rm -f ${INCLUDEDIR}/utils.sh
