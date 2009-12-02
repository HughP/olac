# Just so that when I test the classifier I don't have to type all the loading code.
import pickle
import os
import sys
sys.path.append(os.path.join(sys.path[0],'..'))
from iso639_trainer import *

c = pickle.load(open('classifier.pickle','rb'))
