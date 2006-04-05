# OLAC Makefile

WEB = sb@login.ldc.upenn.edu:language-archives
INDEXES = document_list.xml document_headers.xsl document_index.xsl documents_by_status.xsl documents_by_date.xsl

RSYNC_OPTS = -alrvz -e ssh --relative --include-from=publish.txt
XSLT = java org.apache.xalan.xslt.Process

.PHONY: standards recommendations notes indexes rsync

all: standards recommendations notes indexes rsync

clean:
	rm -rf index.html api
	$(MAKE) -C en clean
	$(MAKE) -C pt-br clean
	$(MAKE) -C slides clean

standards:
	$(MAKE) -C OLAC all

recommendations:
	$(MAKE) -C REC all

notes:
	$(MAKE) -C NOTE all

indexes: $(INDEXES)
	$(XSLT) -in document_list.xml -xsl document_headers.xsl > document_headers.xml
	$(XSLT) -in document_list.xml -xsl document_index.xsl > document_index.html
	$(XSLT) -in document_list.xml -xsl documents_by_status.xsl > documents_by_status.html
	$(XSLT) -in document_list.xml -xsl documents_by_date.xsl > documents_by_date.html

rsync:
	rsync $(RSYNC_OPTS) . $(WEB)

