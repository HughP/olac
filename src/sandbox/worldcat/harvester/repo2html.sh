#!/bin/bash

java -jar saxon9.jar -xsl:repository2html.xsl -s:$1 -o:$1.html
