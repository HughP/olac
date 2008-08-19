# slurp a file into a string
def file2string(fileName):
    """file2 string reads the contents of a file into a string
    param: fileName
    returns: string (contents of file)"""
    file = open(fileName)
    str = file.readlines()
    return ''.join(str)

