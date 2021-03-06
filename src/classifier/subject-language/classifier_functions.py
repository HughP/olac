#/usr/bin/python
# Defines a set of functions that iso639_trainer calls when classifying.  These
# are the 10 schemas defined in wiki:SubjectLanguageClassifier - A boolean
# classifier.

def f1(lang, country, region):
    '''1. Lang'''
    return lang

def f2(lang, country, region):
    '''2. Lang ^ Country, Lang'''
    intersect = lang.intersection(country)
    if intersect:
        return intersect
    else:
        return lang

def f3(lang, country, region):
    '''3. Lang ^ Region, Lang'''
    intersect = lang.intersection(region)
    if intersect:
        return intersect
    else:
        return lang

def f4(lang, country, region):
    '''4. Lang ^ Country, Lang ^ Region, Lang'''
    intersect = lang.intersection(country)
    if intersect:
        return intersect
    else:
        intersect = lang.intersection(region)
        if intersect:
            return intersect
        else:
            return lang

def f5(lang, country, region):
    '''5. Lang ^ Region, Lang ^ Country, Lang'''
    intersect = lang.intersection(region)
    if intersect:
        return intersect
    else:
        intersect = lang.intersection(country)
        if intersect:
            return intersect
        else:
            return lang

def f6(lang, country, region):
    '''6. Lang ^ Country ^ Region, Lang ^ Country, Lang'''
    intersect = lang.intersection(country).intersection(region)
    if intersect:
        return intersect
    else:
        intersect = lang.intersection(country)
        if intersect:
            return intersect
        else:
            return lang

def f7(lang, country, region):
    '''7. Lang ^ Country ^ Region, Lang ^ Region, Lang'''
    intersect = lang.intersection(country).intersection(region)
    if intersect:
        return intersect
    else:
        intersect = lang.intersection(region)
        if intersect:
            return intersect
        else:
            return lang

def f8(lang, country, region):
    '''8. Lang ^ Country ^ Region, Lang ^ Country, Lang ^ Region, Lang'''
    intersect = lang.intersection(country).intersection(region)
    if intersect:
        return intersect
    else:
        intersect = lang.intersection(country)
        if intersect:
            return intersect
        else:
            intersect = lang.intersection(region)
            if intersect:
                return intersect
            else:
                return lang

def f9(lang, country, region):
    '''9. Lang ^ Country ^ Region, Lang ^ Region, Lang ^ Country, Lang'''
    intersect = lang.intersection(country).intersection(region)
    if intersect:
        return intersect
    else:
        intersect = lang.intersection(region)
        if intersect:
            return intersect
        else:
            intersect = lang.intersection(country)
            if intersect:
                return intersect
            else:
                return lang

def f10(lang, country, region):
    '''10. Lang ^ (Country v Region), Lang'''
    intersect = lang.intersection(country.union(region))
    if intersect:
        return intersect
    else:
        return lang

functions = [f1,f2,f3,f4,f5,f6,f7,f8,f9,f10]
function_labels = [
    '1. Lang',
    '2. Lang ^ Country, Lang',
    '3. Lang ^ Region, Lang',
    '4. Lang ^ Country, Lang ^ Region, Lang',
    '5. Lang ^ Region, Lang ^ Country, Lang',
    '6. Lang ^ Country ^ Region, Lang ^ Country, Lang',
    '7. Lang ^ Country ^ Region, Lang ^ Region, Lang',
    '8. Lang ^ Country ^ Region, Lang ^ Country, Lang ^ Region, Lang',
    '9. Lang ^ Country ^ Region, Lang ^ Region, Lang ^ Country, Lang',
    '10. Lang ^ (Country v Region), Lang']

def weighted(NE_dict, a, b):
    results = {}

    langdict = {}
    _populate_langdict(NE_dict['sn'], langdict, 1.0)
    _populate_langdict(NE_dict['wn'], langdict, 0.7)
    
    if NE_dict['cn'].values():
        country = reduce(set.union, NE_dict['cn'].values())
    else:
        country = set()
    if NE_dict['rg'].values():
        region = reduce(set.union, NE_dict['rg'].values())
    else:
        region = set()

    for iso in langdict:
        l = langdict[iso]
        c = 0.0
        r = 0.0
        if iso in country:
            c = 1.0
        if iso in region:
            r = 1.0
        results[iso] = l + a*(l*c) + b*(l*r)

    return results

def _populate_langdict(input_dict, langdict, C):
    for NE in input_dict:
        NE_len = len(NE.split())
        for iso in input_dict[NE]:
            try:
                langdict[iso] += NE_len*C
            except KeyError:
                langdict[iso] = NE_len*C
