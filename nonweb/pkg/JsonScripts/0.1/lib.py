import os
import sys
import codecs
import olac

ssdir = olac.olacvar('webapi/staticdir')

def dumpcall(func, args=[], path=None):
    """
    Run function "func" and store the result to the static web services dir.

    @param func: A PyWebAPI function.
    @param args: Arguments to func.
    @param path: Directory path to prefix the result file name.
    """

    if path:
        fpath = os.path.join(path, func.__name__)
    else:
        fpath = func.__name__
    
    if args:
        fpath = os.path.join(fpath, '/'.join(args))

    fpath += '.txt'
    
    sspath = os.path.join(ssdir, fpath)

    dirname = os.path.dirname(sspath)
    
    if not os.path.exists(dirname):
        try:
            os.makedirs(dirname, 0775)
        except os.error:
            print >>sys.stderr, "Can't create dir:", dirname
            sys.exit(1)
    elif not os.path.isdir(dirname):
        print >>sys.stderr, "Regular file found instead of directory:", dirname
        sys.exit(1)

    try:
        out = codecs.open(sspath+'.tmp', 'w', 'utf-8')
    except os.error, e:
        print >>sys.stderr, "Failed to create file:", sspath+".tmp"
        print >>sys.stderr, e
        sys.exit(1)

    try:
        out.write(apply(func, args))
    except:
        print >>sys.stderr, "Failed to call function:", func.__name__
        sys.exit(1)
        
    try:
        os.rename(sspath+'.tmp', sspath)
    except os.error, e:
        print >>sys.stderr, "Failed to create file:", sspath
        print >>sys.stderr, e
        sys.exit(1)

