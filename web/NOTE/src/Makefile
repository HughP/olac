# Build documents

XSLT = java org.apache.xalan.xslt.Process
OLAC_XSL = ../../OLAC_doc.xsl


### Documents in the OLAC Process

DISPLAY = olac_display-20020810.html olac_display-20030215.html
QUERY   = query-20021102.html query-20030729.html
VISER   = viser-20021102.html viser-20030729.html

HTML = $(DISPLAY) $(QUERY) $(VISER)


### Build

.SUFFIXES: .xml .html

.PHONY: docs install

all: docs install

install: latest html
	mv $(HTML) ..
	ln -s -f olac_display-20030215.html olac_display.html
	ln -s -f query-20030729.html query.html
	ln -s -f viser-20030729.html viser.html

.xml.html:
	$(XSLT) -in $< -xsl $(OLAC_XSL) > $@

