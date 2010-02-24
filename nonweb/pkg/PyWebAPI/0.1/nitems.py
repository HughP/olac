"""
Furnctions around the olacvar('data/num_items_by_country') table.
Provide information on the number of OLAC items by country and area.
"""

import olac
import simplejson as json

def getTable(*args, **kwargs):
    """
    @return: The entire table.
    """
    tabfile = olac.olacvar('data/num_items_by_country')
    f = open(tabfile)
    f.readline()
    L = []
    for l in f:
        a = l.rstrip("\r\n").split('\t')
        a[3] = int(a[3])  # number of items
        a[4] = int(a[4])  # number of items ex lang with >10M speakers
        L.append(a)
    return json.dumps(L)
        
def byCountryCode(*args, **kwargs):
    """
    @param args[0]: Language code.
    @param args[1]: Whether exclude large langs. Either "true" or "false".
                    Optional.
    @return: Number of items for given country.
    """
    if len(args) > 1 and args[1].lower() in ("1","true"):
        idx = 4
    else:
        idx = 3
    tabfile = olac.olacvar('data/num_items_by_country')
    f = file(tabfile)
    f.readline()  # skip header
    for l in f:
        a = l.rstrip("\r\n").split('\t')
        if a[2] == args[0]:
            return json.dumps(int(a[idx]))
    return json.dumps(0)

def byArea(*args, **kwargs):
    """
    @param args[0]: Case insensitive area name.
    @param args[1]: Whether exclude large langs. Either "true" or "false".
                    Optional.
    @return: Number of items for given area.
    """
    if len(args) > 1 and args[1].lower() in ("1","true"):
        idx = 4
    else:
        idx = 3
    tabfile = olac.olacvar('data/num_items_by_country')
    f = open(tabfile)
    f.readline()
    n = 0
    for l in f:
        a = l.rstrip("\r\n").split('\t')
        if a[0].lower() == args[0].lower():
            n += int(a[idx])
    return json.dumps(n)

