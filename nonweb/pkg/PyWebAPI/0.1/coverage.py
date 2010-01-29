import olac
import simplejson as json

def getTable(*args, **kwargs):
    """
    @return: Combined table.
    """
    tabfile = olac.olacvar('data/coverage')
    f = open(tabfile)
    f.readline()
    L = [l.rstrip("\r\n").split('\t') for l in f]
    return json.dumps(L)
        
def getLanguageTable(*args, **kwargs):
    """
    @return: Language coverage table.
    """
    tabfile = olac.olacvar('data/coverage')
    f = open(tabfile)
    f.readline()
    L = []
    for l in f:
        a = l.rstrip("\r\n").split('\t')
        row = []
        row.append(a[0])
        row.append(int(a[1]))
        row.append(int(a[2]))
        row.append(int(a[3]))
        L.append(row)
    return json.dumps(L)

def getOnlineResTable(*args, **kwargs):
    """
    @return: Online resources coverage table.
    """
    tabfile = olac.olacvar('data/coverage')
    f = open(tabfile)
    f.readline()
    L = []
    for l in f:
        a = l.rstrip("\r\n").split('\t')
        row = []
        row.append(a[0])
        row.append(int(a[1]))
        row.append(int(a[4]))
        row.append(int(a[5]))
        L.append(row)
    return json.dumps(L)
