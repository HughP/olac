For documentation purposes, here are the steps that I used to update the iso639.xsl file:

   1. I exported an excel spreadsheet of the LCSH_to_639 table from the Access DB Joan gave me, containing several columns.
   2. I moved columns around and dropped unnecessary ones so that I just had LCSH, subfield-y, and Identifier, in that order.
   3. I sorted the subfield y column so that all the NON blanks floated to the top, this is so that the entries that have a '--' in the name will match first (longest match first)
   4. I then did File -> Save As and set Save As Type to "Unicode Text".  Excel's "Unicode Text" is apparently a UTF-16 tab-delimited file.  I would have preferred a UTF-8 tab delimited file, but I couldn't figure out how to do that
   5. I wrote a python script to convert the tab-file into XSL condition statements.  The script is named iso639_tabfile_to_xml.py and is located in the marc/scripts directory.
   6. I saved the file in step 4 into the marc/scripts directory, and ran the python program on the command line like this: (I named my tab file iso639_map.txt, but you can name it whatever)
          *

            python is639_tabfile_to_xml.py iso639_map.txt

   7. The python script produces the file lcsh.out This text file contains the XSL condition statements
   8. I opened the iso639.xsl XSL file in Oxygen from the marc-crosswalk/lib directory and pasted the condition statements from the two output files in step 7 into the iso639.xsl file, replacing the condition statements that were currently there.

