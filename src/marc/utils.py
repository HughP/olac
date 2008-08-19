# slurp a file into a string
def file2string(fileName):
    """file2string(fileName)
    purpose: read the contents of a file into a string
    param: fileName
    returns: string (contents of file)"""
    file = open(fileName)
    str = file.readlines()
    return ''.join(str)

def cfglist2dict(list):
    """cfglist2dict(list)
    purpose: conver a config list of names/values into a dictionary
    param: config list
    return: dictionary """
    d = {}
    for (name,value) in list:
        d[name] = value
    return d
