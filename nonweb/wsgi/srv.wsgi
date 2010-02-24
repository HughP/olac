import sys
import os
import cgi
import olac
sys.path.insert(0,olac.olacvar('pywebapi'))
os.environ['PYTHON_EGG_CACHE'] = olac.olacvar('python/egg_cache/wsgi')

def my_import(components):
    base = olac.olacvar('pywebapi')
    steps = components[:-1]
    args = components[-1:]
    while steps:
        p1 = os.path.join(base, '/'.join(steps))
        p2 = p1 + ".py"
        
        if os.path.isdir(p1):
            if os.path.isfile(os.path.join(p1,'__init__.py')):
                break

        if os.path.isfile(p2):
            break

        args.insert(0, steps.pop())

    callable_name = args.pop(0)

    try:
        if not steps:
            if 'default' in globals():
                mod = reload('default')
            else:
                mod = __import__('default', fromlist=[callable_name])
        else:
            modnam = '.'.join(steps)
            if modnam in globals():
                mod = reload(modnam)
            else:
                mod = __import__(modnam, fromlist=[callable_name])
        return getattr(mod, callable_name), args
    except AttributeError:
        pass


def application(environ, start_response):
    args = environ['PATH_INFO'].split('/')[1:]
    kwargs = {}
    for k,v in cgi.parse_qs(environ['QUERY_STRING']).items():
        kwargs[k] = v[0]

    f = my_import(args)
    
    if f and callable(f[0]):
        headers = [('Content-type', 'text/plain')]
        start_response('200 OK', headers)
        return f[0](*f[1], **kwargs)
    else:
        headers = [('Content-type', 'text/plain')]
        start_response('404 Not Found', headers)
        return '404 Not Found'

