"""
Throwaway script that processes the olac classification results on June 29th
to see how many iso codes were identified for each record and for how many
records were that number of iso codes identified.
"""
from operator import itemgetter
from nltk.probability import FreqDist

fd = FreqDist()
results_file = open('olac_iso_identification_results').readlines()
# this took like 15 minutes to get.
# not too bad, considering it's like all of olac. 
num_records = len(results_file)+0.0
for line in results_file:
    record = line.strip().split('\t')
    iso_list = record[-1].split()
    fd.inc(len(iso_list))

print "num\tfreq\tpercentage of records"
for num, freq in sorted(fd.items(), key=itemgetter(1), reverse=True):
    print str(num)+'\t'+str(freq)+'\t'+str(freq/num_records)
print ''
print 'Number of records: '+str(num_records)