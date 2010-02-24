"""
Furnctions around the olacvar('data/num_items_by_country') table.
Provide information on the number of OLAC items by country and area.
"""

import olac
import simplejson as json

def getTable(*args, **kwargs):
    """
    @return: The entire table defined as (area,country,country code,# items).
    """
    tabfile = olac.olacvar('data/num_items_by_country')
    f = open(tabfile)
    f.readline()
    L = []
    for l in f:
        area, cname, ccode, num = l.rstrip("\r\n").split('\t')
        L.append([area,cname,ccode,int(num)])
    return json.dumps(L)
        
def byCountryCode(*args, **kwargs):
    """
    @return: Number of items for given country.
    """
    tabfile = olac.olacvar('data/num_items_by_country')
    f = file(tabfile)
    f.readline()  # skip header
    for l in f:
        area, cname, ccode, num = l.rstrip("\r\n").split('\t')
        if ccode == args[0]:
            return json.dumps(int(num))
    return json.dumps(0)

def byArea(*args, **kwargs):
    """
    @param args[0]: Case insensitive area name.
    @return: Number of items for given area.
    """
    tabfile = olac.olacvar('data/num_items_by_country')
    f = open(tabfile)
    f.readline()
    n = 0
    for l in f:
        area, cname, ccode, num = l.rstrip("\r\n").split('\t')
        if area.lower() == args[0].lower():
            n += int(num)
    return json.dumps(n)

