# Build documents

XSLT = java org.apache.xalan.xslt.Process
OLAC_XSL = ../OLAC_doc.xsl
LATEST = ../document_latest.sh

### Documents in the OLAC Process

DISPLAY = olac_display-20020810.html olac_display-20030215.html
QUERY   = query-20021102.html query-20030729.html
VISER   = viser-20021102.html viser-20030729.html

HTML = $(DISPLAY) $(QUERY) $(VISER)


### Build

.SUFFIXES: .xml .html

.PHONY: all

all: $(HTML)
	$(LATEST) olac_display  20030215
	$(LATEST) query         20030729
	$(LATEST) viser         20030729

.xml.html:
	$(XSLT) -in $< -xsl $(OLAC_XSL) > $@

