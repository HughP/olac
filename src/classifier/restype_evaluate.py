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

if len(sys.argv)!=2:
    sys.exit("Usage: python restype_evaluate.py classifier-output")

correct = 0
input = open(sys.argv[1]).readlines()
for line in input:
    name, true_label, data = line.strip().split('\t')
    assigned_label = data.split()[0].split(':')[0]
    if true_label.strip()==assigned_label:
        correct += 1

print "Accuracy:", float(correct)/len(input)
