#!/usr/bin/python
'''Evaluates output of resource type classifier and outputs accuracy.'''
import sys

if len(sys.argv)!=2:
    sys.exit("Usage: python restype_evaluate.py classifier-output")

correct = 0
input = open(sys.argv[1]).readlines()
for line in input:
    name, true_label, data = line.strip().split('\t')
    assigned_label = data.split()[0].split(':')[0]
    if true_label==assigned_label:
        correct += 1

print "Accuracy:", float(correct)/len(input)
