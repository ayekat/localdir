# Installation prefix:
PREFIX = ~/.local

# Application name:
APPNAME = open

# Default: Do nothing
all:

# Handy actions:
install:
	install ${APPNAME} ${PREFIX}/bin/${APPNAME}
uninstall:
	rm -f ${PREFIX}/bin/${APPNAME}

# Phony targets:
.PHONY: all
.PHONY: install
.PHONY: uninstall
