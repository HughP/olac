# OLAC Makefile

WEB = sb@login.ldc.upenn.edu:language-archives
INDEXES = document_list.xml document_headers.xsl document_index.xsl documents_by_status.xsl documents_by_date.xsl

RSYNC_OPTS = -alrvz -e ssh --relative --include-from=publish.txt
XSLT = /home/sb/language-archives/xalan

.PHONY: standards recommendations notes indexes rsync

all: standards recommendations notes indexes rsync

clean:
	rm -rf index.html api
	$(MAKE) -C en clean
	$(MAKE) -C pt-br clean
	$(MAKE) -C slides clean

standards:
	$(MAKE) -C OLAC/src all

recommendations:
	$(MAKE) -C REC/src all

notes:
	$(MAKE) -C NOTE/src all

indexes: $(INDEXES)
	$(XSLT) document_list.xml document_headers.xsl > document_headers.xml
	$(XSLT) document_list.xml document_index.xsl > document_index.html
	$(XSLT) document_list.xml documents_by_status.xsl > documents_by_status.html
	$(XSLT) document_list.xml documents_by_date.xsl > documents_by_date.html

rsync:
	rsync $(RSYNC_OPTS) . $(WEB)

