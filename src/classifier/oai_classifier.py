"""
Build a classifier that determines the appropriate label for a
record, based on its features.
"""

from tabdbreader import TabDBCorpusReader
import nltk

######################################################################
## Customization Constants
######################################################################

TRAIN_PERCENT = 50
"""Indicates what percent of the corpus should be used for training
   (vs testing)."""

ALGORITHM = 'LBFGSB'
"""Use megam for training the maxent classifier, since it's fast and
   does a good job.  If you don't want to install megam, then change
   this to None to use the default algorithm, or to any other supported
   algorithm (eg 'TADM' or 'LBFGSB')."""

######################################################################
## Feature Detector
######################################################################

def feature_detector(record):
    """
    Given an OLAC record, return a feature dictionary indicating
    what information should be used by the machine learning
    algorithm to determine the label for a given record.
    """
    # Note: several global variables used by this feature detector
    # (e.g., FIELDS and WORD_FEATURES) are defined below, based on
    # a scan through all of the training data.
    
    features = {'alwayson': True}
    for field in FIELDS:
        features['has(%s)' % field] = (field in record)

    if 'description' in record:
        record_words = set(record['description'].split())
        for word in WORD_FEATURES:
            features['descr(%s)' % word] = (word in record_words)

    return features

######################################################################
## Helper Functions
######################################################################

def find_word_features(records):
    """
    Return a list of words that appear in at least 3 separate
    records' description fields.
    """
    wordfreq = nltk.FreqDist()
    for record in records:
        if 'description' in record:
            for word in set(record['description'].split()):
                wordfreq.inc(word)
    return [w for w in wordfreq if wordfreq[w] > 3]

def find_fields(records):
    """
    Return a list of all fields that are used by the given records.
    """
    fields = set()
    for record in records:
        fields.update(record)
    return fields
        


######################################################################
## Main
######################################################################

if __name__ == '__main__':
    # Read the corpora.
    reader = TabDBCorpusReader('oai_classifier_trn', '.*db\.tab')
    
    olac_records = reader.records('olacdb.tab')
    olac_train = olac_records[:len(olac_records)*TRAIN_PERCENT/100]
    olac_test = olac_records[len(olac_records)*TRAIN_PERCENT/100:]
    
    oai_records = reader.records('oaidb.tab')
    oai_train = oai_records[:len(oai_records)*TRAIN_PERCENT/100]
    oai_test = oai_records[len(oai_records)*TRAIN_PERCENT/100:]
    
    # Scan the records 
    WORD_FEATURES = find_word_features(olac_train + oai_train)
    FIELDS = find_fields(olac_train + oai_train)
    
    # Tag the records with a label (yes/no depending on whether it came
    # from olac or oai), and apply the feature detector.
    fd = feature_detector
    train_data = (
        nltk.util.LazyMap(lambda v: (fd(v), 'YES'), olac_train) +
        nltk.util.LazyMap(lambda v: (fd(v), 'NO'), oai_train))
    test_data = (
        nltk.util.LazyMap(lambda v: (fd(v), 'YES'), olac_train) +
        nltk.util.LazyMap(lambda v: (fd(v), 'NO'), oai_train))
    
    # Train a classifier
    classifier = nltk.MaxentClassifier.train(train_data, ALGORITHM)
    
    # Display its accuracy
    print 'Classifier accuracy:',
    print nltk.classify.accuracy(classifier, test_data)
    
    # Display the most useful features
    classifier.show_most_informative_features()
            

                   
        
