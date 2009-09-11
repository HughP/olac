'''Compares iso639Classifier results to a gold standard.

Created on Jul 8, 2009

@author: Joshua S Hou

Compares iso639Classifier results to a gold standard and prints out precision
and recall numbers.

Usage: python iso639_evaluate_round_robin.py gold_standard classifier_output > results
'''

import sys
import os
from operator import iand

def compare_classification(gold_standard, test_classifications):
    '''Compares results from test classification to gold standard, gs, and
    returns precision and recall.'''
    tc = [open(i).readlines() for i in test_classifications]
    gs = open(gold_standard).readlines()
    
    lists = [len(filter(lambda x: x[0]!='#', i))!=len(gs) for i in tc]
    if len(lists)==0 or reduce(iand, lists):
        print "Error: test set has different number of records than gold standard."
        return None
    
    T = [0]*len(test_classifications) # number of codes assigned by classifier (from test)
    G = [0]*len(test_classifications) # number of codes in metadata (from gold standard)
    I = [0]*len(test_classifications) # number of codes in intersection
    params = [i[1].strip()[11:-1].split(', ') for i in tc]
    thresholds = [i[0][13:].strip() for i in tc]
    
    test_idx = 0
    gs_idx = 0
    
    while test_idx<len(tc[0]):
        if tc[0][test_idx][0]!='#':
            for i in range(len(test_classifications)):
                test_isos = set(tc[i][test_idx].strip('\n').split('\t')[1].split())
                gs_isos = set(gs[gs_idx].strip('\n').split('\t')[1].split())
                if 'high_score' in test_isos:
                    test_isos.remove('high_score')

                T[i] +=  len(test_isos)
                G[i] += len(gs_isos)
                I[i] += len(test_isos.intersection(gs_isos))
    #           print i, test_isos, gs_isos
            gs_idx += 1
        test_idx += 1
    #[sys.stdout.write(str(T[i])+'\t'+str(G[i])+'\t'+str(I[i])+'\n') for i in range(len(test_classifications))]
    #print "=============================================="
    return thresholds, params, [{'precision':float(I[j])/T[j], 'recall':float(I[j])/G[j]} for j in range(len(test_classifications))]

def main():
    gold_standard = "test_data/iso639_test2.gs"
    test_classifications = map(lambda x: "experiments/b/"+x, filter(lambda x:x.endswith('.txt'),os.listdir('experiments/b')))
    thresholds, params, results = compare_classification(gold_standard, test_classifications)
    print '\t'.join(['threshold','snw','wnw','a','b','precision','recall'])
    for i in range(len(thresholds)):
        print thresholds[i]+'\t' + '\t'.join(params[i]) + '\t' + '\t'.join([str(results[i]['precision']), str(results[i]['recall'])])

if __name__=="__main__":
    main()
