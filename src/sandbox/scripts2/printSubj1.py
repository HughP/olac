import pymarc
import sys

# get tag from command-line
#tag = sys.argv.pop()
#print 'outputting tag ',tag

#f = open('sample.marc','w')
ctr = 0
marcset = pymarc.MARCReader(open('c:\olac\gial.marc'))
sub = {}
all = {}

# this loop creates two dictionary structures:
#   {sub} agregates strings on a subfield basis
#   {all} agregates the entire subject string
#   Goal:
#       to add subjects to the above dictionaries that are attached
#       to language resources having a subject heading containing the world 'language'
#       we don't care about the heading with 'language' in it itself though
for rec in marcset:
    ctr += 1
    found = 0
    for tag in (600,610,611,630,650):
        tag = str(tag)
        if (rec[tag] and rec[tag].value().lower().find('language') != -1):
            full_string = ''
            for (subfield,subval) in rec[tag]:
                #print 'sf=',type(subfield)
                #print 'sv=',type(subval)
                if (subfield in sub):
                    if (subval in sub[subfield]):
                        sub[subfield][subval] += 1
                        pass
                    else:
                        sub[subfield][subval] = 1
                else:
                    sub[subfield] = {} # create new dict for subfield
                full_string = full_string + subval + '--'
            full_string = full_string[0:-2] # remove trailing --
            if (full_string in all):
                all[full_string] += 1
                pass
            else:
                all[full_string] = 1
            #print rec['001'].value(),' : ',tag,':',full_string
            found = 1
    if (found == 1):
        #print
        pass
for s in all:
    #print '%s\t%s' % (all[s],s) # count,string
    print '%s\t%s' % (s,all[s]) # string,count

# how to invert a dictionary
# dict([v,k] for k,v in mydict.items())


