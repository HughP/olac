"""
Simple harvester that uses OAI-PMH to download DC records from archive.org.
Requires simple_harvester.py.

Usage:

  python ia_harvester.py <collection_id> <output_file>

"""


import sys
import os
import urllib
import re
import simple_harvester

def harvest_ia(collection_id, output):
    baseurl = "http://www.archive.org/services/oai.php"
    metadata_prefix = "oai_dc"
    set_name = "collection:" + collection_id

    def callback1(url):
        print "Downloading %s ..." % url
    def callback2(num_records, size):
        print "Wrote %d records (%d bytes) to %s" % (num_records, size, output)

    outfile = open(output, 'wb')
    h = simple_harvester.Harvester(outfile, baseurl, metadata_prefix,
                                   callback1, callback2)
    h.harvest(set_name)
    h.harvest(set_name + '_audio')
    h.harvest(set_name + '_video')
    h.close()


if __name__ == "__main__":
    if len(sys.argv) != 3:
        print """\
Usage: python %s <collection_id> <output_filename>

    <collection_id>
        Collection ID registered with archive.org site, e.g.
        "rosettaproject", "LanguageCommons", etc.

    <output_filename>
        Name of the file to store the downloaded records.

""" % os.path.basename(sys.argv[0])
        sys.exit(1)

    collection_id = sys.argv[1]
    output = sys.argv[2]  # file to store the result

    harvest_ia(collection_id, output)

