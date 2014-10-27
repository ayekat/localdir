INSTALLDIR=/usr/local

all:
	mkdir -p build
	sed -e "s/@INSTALLDIR@/$(shell echo "${INSTALLDIR}" | sed 's/\//\\\//g')/g"\
		scrock.service > build/scrock.service
	cp scrock build/scrock

install:
	install --mode=0755 scrock ${INSTALLDIR}/bin/scrock
	install --mode=0644 scrock.service /usr/lib/systemd/system/scrock.service
	systemctl daemon-reload

uninstall:
	rm -f ${INSTALLDIR}/bin/scrock
	rm -f /usr/lib/systemd/system/scrock.service
	systemctl daemon-reload

clean:
	rm -rf build

.PHONY: all
.PHONY: install
.PHONY: uninstall
.PHONY: clean
