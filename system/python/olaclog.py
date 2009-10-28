import sys
from olacvar import olacvar

__all__ = ["openlog", "log"]

try:
    import syslog

    def openlog(prefix):
        fac = olacvar('syslog/facility')
        if fac == '/dev/null':
            fac = syslog.LOG_LOCAL0
        else:
            try:
                fac = eval('syslog.%s' % fac)
            except:
                msg1 = 'WARNING: Unrecognized logging facility: %s\n' % fac
                msg2 = 'WARNING: LOG_LOCAL will be used\n'
                sys.stderr.write(msg1)
                sys.stderr.write(msg2)
                fac = syslog.LOG_LOCAL0
        syslog.openlog(prefix, syslog.LOG_PID, fac)
    
    def log(msg):
        syslog.syslog(msg)

except ImportError:
    sys.stderr.write("WARNING: Failed to load syslog module.\n")
    sys.stderr.write("WARNING: Logging to log daemon is diabled.\n")
    openlog = log = lambda x: None
