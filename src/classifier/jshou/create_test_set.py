'''Creates a test set from OLAC records for classification.

Created on Jul 8, 2009

@author: Joshua S Hou

Reads a tab delimited file of OLAC records and finds the records with ISO 639
codes and outputs those, as well as a classification output based on those codes
in order to create a gold standard.

Usage: python create_test_set.py test_set gold_standard  
'''
import sys
from tabdbreader2 import *
from util import check_file

def print_records(records, outstream):
    '''records is a list of OLAC records.'''
    print>>outstream, "Archive_ID\tItem_ID\tElement_ID\tOaiIdentifier\tTagName\tType\tCode\tContent"
    newline = re.compile('\n')
    elt_id = 'NULL'
    record_unique_elements = ['Archive_ID','Item_ID','Oai_ID']
    for record in records:
        archive_id, item_id, oai_id = [record[i] for i in record_unique_elements]
        for element in record.keys():
            if element not in record_unique_elements:
                if element=='iso639':
                    for iso in record[element].strip().split():
                        print>>outstream, '\t'.join([archive_id,item_id,elt_id,oai_id,\
                                                 'subject','language',iso,''])
                else:
                    record[element] = newline.sub(r'\\n',record[element])
                    if '\n' in record[element]:
                        print record[element]
                        sys.exit(1)
                    print>>outstream, '\t'.join([archive_id,item_id,elt_id,oai_id,\
                                                 element,'NULL','NULL',record[element]])

if __name__=="__main__":
    if len(sys.argv)!=4:
        print "Usage: python create_test_set.py olac_records test_set gold_standard"
        sys.exit(1)
    records, test_set, gold_std = sys.argv[1:]
    
    test_set = check_file(test_set)
    gold_std = check_file(gold_std)
    
    reader = TabDBCorpusReader('.', '.*db\.tab')
    olac_records = reader.records(records)
    
    iso639_records = []
    for record in olac_records:
        if 'iso639' in record:
            iso639_records.append(record)
    
    print_records(iso639_records,test_set)
    for record in iso639_records:
        try:
            title = record['title']
        except KeyError:
            title = ''
        print>>gold_std, '\t'.join([record['Oai_ID'], record['iso639'], title])