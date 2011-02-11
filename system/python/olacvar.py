import sys
import os
import re

__all__ = ['olacvar']

def read_config_line(filename):
    if os.access(filename, os.R_OK):
        for line in open(filename):
            if ((not line.startswith('#')) and line.strip()):
                return line.strip()

    return '/null/value'


if (os.path.exists('/etc/olacbase') and os.access('/etc/olacbase', os.R_OK)):
    olachome = read_config_line('/etc/olacbase')
elif ('OLACBASE' in os.environ):
    olachome = os.environ['OLACBASE']
else:
    olachome = '/null/value'

def olacvar(varname = None, interpret = True):
    if (varname and olachome):
        path = os.path.join(olachome, 'conf', varname)
        if os.path.isfile(path):
            line = read_config_line(path)
            q = final = []
            tmp = []
            i = 0
            while (i < len(line)):
                c = line[i]
                if (c == '\\'):
                    if ((i + 1) < len(line)):
                        i += 1
                elif (c == '$'):
                    if ((i + 1) < len(line)):
                        if (line[(i + 1)] == '{'):
                            tmp = []
                            q = tmp
                            i += 2
                elif (c == '}'):
                    if (q is tmp):
                        final.append(olacvar(''.join(tmp)))
                        q = final
                        i += 1
                        continue
                elif (c == '^'):
                    if (q is not tmp):
                        q.append(olachome)
                        i += 1
                        continue
                elif (c == '!'):
                    if (q is not tmp):
                        s = ''.join(q)
                        q = final = []
                        j = (max(s.rfind(' '), s.rfind('\t')) + 1)
                        q.append(s[:j])
                        q.append(os.path.join(olachome, 'svn/nonweb/pkg', s[j:], 'Current'))
                        q.append('/')
                        i += 1
                        continue
                q.append(line[i])
                i += 1

            return ''.join(q)
    return '/null/value'

