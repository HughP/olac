# Build documents

XSLT = java org.apache.xalan.xslt.Process
OLAC_XSL = ../OLAC_doc.xsl
LATEST = ../document_latest.sh

### Documents in the OLAC Process

ACCESS    = access-20021119.html
DISCOURSE = discourse-20021121.html discourse-20021217.html discourse-20030127.html
FIELD     = field-20021127.html field-20030121.html
LANGUAGE  = language-20010319.html language-20031213.html
ROLE      = role-20021119.html role-20030827.html role-20031010.html
TYPE      = type-20010320.html type-20020612.html type-20020628.html type-20021121.html type-20021212.html

HTML = $(ACCESS) $(DISCOURSE) $(FIELD) $(LANGUAGE) $(ROLE) $(TYPE)


### Build

.SUFFIXES: .xml .html

.PHONY: all

all: $(HTML)
	$(LATEST) access     20021119
	$(LATEST) discourse  20030127
	$(LATEST) field      20030121
	$(LATEST) language   20031213
	$(LATEST) role       20031010
	$(LATEST) type       20021212

.xml.html:
	$(XSLT) -in $< -xsl $(OLAC_XSL) > $@

