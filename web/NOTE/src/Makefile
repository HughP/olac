# Build documents

XSLT = ../../xalan
OLAC_XSL = ../../OLAC_doc.xsl


### Documents in the OLAC Process

DISPLAY = olac_display-20020810.html olac_display-20030215.html
QUERY   = query-20021102.html query-20030729.html
VISER   = viser-20021102.html viser-20030729.html

HTML = $(DISPLAY) $(QUERY) $(VISER)


### Build

.SUFFIXES: .xml .html

.PHONY: docs latest install

all: docs latest install

html: $(HTML)

latest: html
	ln -s olac_display-20030215.html olac_display.html
	ln -s query-20030729.html query.html
	ln -s viser-20030729.html viser.html

install: latest html
	mv $(ALL) ..

.xml.html:
	$(XSLT) $< $(OLAC_XSL) > $@

