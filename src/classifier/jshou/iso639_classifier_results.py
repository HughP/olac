'''Compares iso639Classifier results to a gold standard.

Created on Jul 8, 2009

@author: Joshua S Hou

Compares iso639Classifier results to a gold standard and prints out precision
and recall numbers.

Usage: python iso639_classifier_results.py gold_standard classifier_output > results
'''

import sys

def compare_classification(gold_standard, test_classification):
    '''Compares results from test classification to gold standard, gs, and
    returns precision and recall.'''
    tc = open(test_classification).readlines()
    gs = open(gold_standard).readlines()
    
    if len(tc)!=len(gs):
        print "Error: test set has different number of records than gold standard."
        return None
    
    T = 0 # number of codes assigned by classifier (from test)
    G = 0 # number of codes in metadata (from gold standard)
    I = 0 # number of codes in intersection
    
    for i in range(len(tc)):
        test_isos = set(tc[i].strip('\n').split('\t')[1].split())
        gs_isos = set(gs[i].strip('\n').split('\t')[1].split())
        
        T +=  len(test_isos)
        G += len(gs_isos)
        I += len(test_isos.intersection(gs_isos))
    
    return {'precision':float(I)/T, 'recall':float(I)/G}

if __name__=="__main__":
    if len(sys.argv)!=3:
        print "Usage: python iso639_classifier_results.py gold_standard classifier_output > results"
        sys.exit(1)
    
    results = compare_classification(sys.argv[1], sys.argv[2])
    if results:
        print "Precision:", results['precision']
        print "Recall:", results['recall']
        print "F-score:", 2*(results['precision']*results['recall'])/(results['precision']+results['recall'])
    else:
        print "No results."