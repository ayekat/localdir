# Compiler:
CC ?= gcc

# Installation prefix:
PREFIX = ~/.local

# Application name:
APPNAME = xor

# Flags:
CFLAGS  = -W -Wall -Wextra -pedantic -g
CFLAGS += -Wcast-align -Wcast-qual -Wconversion -Wwrite-strings -Wfloat-equal
CFLAGS += -Wlogical-op -Wpointer-arith -Wformat=2
CFLAGS += -Winit-self -Wuninitialized -Wmaybe-uninitialized
CFLAGS += -Wstrict-prototypes -Wmissing-declarations -Wmissing-prototypes
CFLAGS += -Wpadded -Wshadow
CFLAGS += -std=c99
CFLAGS += $(shell pkg-config --cflags ${third_libs})  # XXX

# File names:
SOURCE = xor.c

# Default: Build application
all: $(APPNAME)

# Handy actions:
clean:
mrproper: clean
	rm -f ${APPNAME}
install:
	install ${APPNAME} ${PREFIX}/bin/${APPNAME}
uninstall:
	rm -f ${PREFIX}/bin/${APPNAME}

# Compile/Link:
$(APPNAME): $(SOURCE)
	$(CC) ${CFLAGS} ${SOURCE} -o ${APPNAME}

# Phony targets:
.PHONY: all
.PHONY: clean
.PHONY: mrproper
.PHONY: install
.PHONY: uninstall
