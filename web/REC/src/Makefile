# Build documents

XSLT = java org.apache.xalan.xslt.Process
OLAC_XSL = ../../OLAC_doc.xsl


### Documents in the OLAC Process

ACCESS    = access-20021119.xml
DISCOURSE = discourse-20021121.html discourse-20021217.html discourse-20030127.html
FIELD     = field-20021127.html field-20030121.html
LANGUAGE  = language-20010319.html language-20031213.html
ROLE      = role-20021119.html role-20030827.html role-20031010.html
TYPE      = type-20010320.html type-20020612.html type-20020628.html type-20021121.html type-20021212.html

HTML = $(DISCOURSE) $(FIELD) $(LANGUAGE) $(ROLE) $(TYPE)


### Build

.SUFFIXES: .xml .html

.PHONY: docs install

all: docs install

install: $(HTML)
	mv $(HTML) ..
	ln -s -f access-20021119.html access.html
	ln -s -f discourse-20030127.html discourse.html
	ln -s -f field-20030121.html field.html
	ln -s -f language-20031213.html language.html
	ln -s -f role-20031010.html role.html
	ln -s -f type-20021212.html type.html

.xml.html:
	$(XSLT) -in $< -xsl $(OLAC_XSL) > $@

