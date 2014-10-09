INSTALLDIR=/usr/local

all:
	mkdir -p build
	sed -e "s/@INSTALLDIR@/$(shell echo "${INSTALLDIR}" | sed 's/\//\\\//g')/g"\
		vde/vde.service > build/vde.service
	cp vde/vde build/vde
	sed -e "s/@INSTALLDIR@/$(shell echo "${INSTALLDIR}" | sed 's/\//\\\//g')/g"\
		vls/vls.service > build/vls.service
	cp vls/vls build/vls
	cp vls/vls.conf build/vls.conf

install:
	install --mode=0644 build/vde.service /etc/systemd/system
	install --mode=0644 build/vls.service /etc/systemd/system
	install --mode=0755 build/vde ${INSTALLDIR}/bin
	install --mode=0755 build/vls ${INSTALLDIR}/bin
	test -e /etc/vls.conf || install --mode=644 build/vls.conf /etc/vls.conf
	systemctl daemon-reload

uninstall:
	rm -f /etc/systemd/vde
	rm -f /etc/systemd/vls
	rm -f ${INSTALLDIR}/bin/vde
	rm -f ${INSTALLDIR}/bin/vls
	systemctl daemon-reload

clean:
	rm -rf build

.PHONY: all
.PHONY: install
.PHONY: uninstall
.PHONY: clean
