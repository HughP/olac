#!/usr/bin/python
'''Evaluates output of resource type classifier and outputs accuracy.

Created on Aug 28, 2009

@author: Joshua S Hou

Evaluates the output of mallet resource type classifier, compares actual labels
against the labels assigned by the classifier and prints out the accuracy of the
classifier's labels.

Usage: python restype_evaluate.py classifier-output"
'''
import sys
import operator

if len(sys.argv)!=2:
    sys.exit("Usage: python restype_evaluate.py classifier-output")

# none labels: language none, and none
nones = set(['LNONE','NONE'])

correct = 0
input = open(sys.argv[1]).readlines()
for line in input:
    name, true_labels, data = line.strip().split('\t')
    assigned_labels = data.split()[0].split(':')[0]
    true_labels = set(true_labels.split('&&'))
    if len(true_labels)>1:
        # if multilabel, true_labels must be a subset of assigned_labels
        if reduce(operator.iand,[label in true_labels for label in assigned_labels.split('&&')]):
            correct += 1
    else:
        # if one label, must be exact match
        if assigned_labels in true_labels:
            correct += 1
        elif assigned_labels in nones and true_labels.issubset(nones):
            correct += 1

print "Accuracy:", float(correct)/len(input)
