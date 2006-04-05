# Build documents

XSLT = ../../xalan
OLAC_XSL = ../../OLAC_doc.xsl


### Documents in the OLAC Process

METADATA = metadata-20021211.html metadata-20030531.html metadata-20031208.html metadata-20060331.html

PROCESS = process-20010507.html process-20010521.html process-20021209.html process-20021210.html\
        process-20030625.html process-20030708.html process-20060331.html

REPOSITORIES = repositories-20021211.html repositories-20030528.html repositories-20030716.html\
        repositories-20030917.html repositories-20060331.html

OLACMS = olacms-20010221.html olacms-20010406.html olacms-20010425.html olacms-20010616.html\
        olacms-20011022.html olacms-20011022.html

PROTOCOL = protocol-20011210.html protocol-20021209.html

HTML = $(METADATA) $(PROCESS) $(REPOSITORIES) $(OLACMS) $(PROTOCOL)


### Build

.SUFFIXES: .xml .html

.PHONY: docs latest install

all: docs latest install

html: $(HTML)

latest: html
	ln -s metadata-20060331.html metadata.html
	ln -s process-20060331.html process.html
	ln -s repositories-20060331.html repositories.html

install: latest html
	mv $(ALL) ..

.xml.html:
	$(XSLT) $< $(OLAC_XSL) > $@

