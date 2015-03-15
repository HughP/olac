# Introduction #

We describe a framework for writing ajax servers for OLAC. It is designed to meet some requirements described below.

There is a general direction that we drive the OLAC infrastructure development to. It is about separating viewing and generation of web pages. That is, instead of the pages being generated when they are requested, they can be generated in advance, e.g. nightly.

Here's another way of viewing this separation. Suppose there was a software system. It would create a set of HTML files every night. Everyday, we would take this files and put them onto the doc root of OLAC web server. Note that the web site will be operational as long as we have 1) internet, 2) minimal web server, and 3) the set of HTML files . This minimizes moving part on the web server-- no need for database server, PHP, CGI, etc.

[reason for pywebapi?](Explain.md)


# Overview #

The following diagram shows how the data stored in the database server flows to the client stating from OLAC DB, a MySQL database.

```
              OLAC DB
                 |
                 | Data scripts
                 |
         Static data files
                 |
                 |
                 |
              PyWebAPI
               |    |
               |    |
          ,----'    `-----------.
          |                     |
          |                     | JSON scripts
          |                     |
       srv.wsgi         Static JSON files
```

  * OLAC DB - data stored on a database server
  * Data scripts - read data from OLAC DB and produce static data files
  * Static data files - tab delimited tables, XML files, etc. computed from OLAC DB
  * PyWebAPI - Python API over the static data files
  * srv.wsgi - exposes PyWebAPI for AJAX clients
  * JSON scripts - for each PyWebAPI function, for every possible input to the function, call the function and save the return as a file
  * Static JSON files - files containing a JSON string, which is a result of a PyWebAPI function call



# Data scripts #

Data scripts are responsible for transforming data stored in OLAC DB into data files such as tab-delimited tables and XML files. The data files are static in the sense that they are not dynamically computed to serve real time HTTP requests. The computation usually consists of series of SQL queries and it is done offline in advance.

Each data file is configured with two configuration variables: data/VARNAME and data/VARNAME.script. The value of data/VARNAME is the location of the data file. The value of VARNAME.script is the location of a data script that generates the data file.

Here is an example. The config variable data/coverage contains the location of a data table need for the [coverage page](http://www.language-archives.org/documents/coverage.html).

```
$ olacvar data/coverage
/olac/data/coverage/coverage.tab
```

The config variable data/coverage.script contains the location of the corresponding data script.

```
$ olacvar data/coverage.script
/olac/pkg/DataScripts/Current/generate_coverage_table.py
```

Therefore, the coverage table can be generated as follow.

```
$ $(olacvar data/coverage.script) > $(olacvar data/coverage)
```

As in this example, each data script is responsible for one and only one data file. It takes no input, and output is dumped on standard output.


# PyWebAPI #

PyWebAPI is a collection of Python modules and functions for OLAC. It is intended for AJAX applications, but it can be imported and used by normal Python programs. The configuration variable pywebapi contains the root directory of the modules.

```
$ olacvar pywebapi
/olac/pkg/PyWebAPI/Current/
$ ls $(olacvar pywebapi)
coverage.py
coverage.pyc
...
$ cat $(olacvar pywebapi)/coverage.py
...
def getTable(*args, **kwargs):
    """
    @return: Combined table.
    """
    tabfile = olac.olacvar('data/coverage')
    f = open(tabfile)
    f.readline()
    L = [l.rstrip("\r\n").split('\t') for l in f]
    return json.dumps(L)
...
```

Note that PyWebAPI functions take variable number of positional arguments and variable number of keyword arguments although they might not use the arguments. For example, getTable function shown above doesn't use any arguments.

Each PyWebAPI function can be mapped to a URL. For instance, the getTable function above can be mapped to a URL like http://www.language-archives.org/.../coverage/getTable. This topic will be discussed more in srv.wsgi and JSON scripts sections.


# srv.wsgi #

This is a WSGI script that processes any URL beginning with /srv, e.g. http://www.language-archives.org/srv/coverage/getTable. By doing so, it makes PyWebAPI functions available to AJAX applications.

The path component following /srv is mapped a PyWebAPI function. For example, if /coverage/getTable follows /srv, the search will return the getTable function inside the coverage.py module.

The mapping algorithm works as follows. Let the tailing part of the URL following /srv be

```
/c1/c2/.../cN?k1=v1&...&kN=vN
```

Function (callable) cK is searched using the following search order:

```
__init__.py: callable c1
c1/__init__.py: callable c2
c1.py: callable c2
c2/__init__.py: callable c3
c2.py: callable c3
...
cN-1/__init__.py: callable cN
cN-1.py: callable cN
```

If found, function cK is called with (cK+1, ..., cN) as positional arguments and {k1=v1, ..., kN=vN} as keyword arguments. The result is transformed into a JSON string and returned.

If no such function is found, HTTP response "404 Not Found" is returned.

For example, the following URL:

```
http://www.language-archives.org/srv/nitems/byCountryCode/US
```

returns the number of archived items whose country code is US.


# JSON scripts #

JSON scripts pre-compute PyWebAPI functions. If we express this as a pseudo Python code, it looks like this:

```
for f in all PyWebAPI functions:
    for x in all possible input for f:
        value = f(x)
        save_as_file(value)
```

Because the files are stored inside the document root of the web server, the files can be accessed via HTTP protocol. The content of the files is a JSON string intended to be consumed by AJAX applications.

The root directory to store the return values is configured by the webapi/staticdir variable.

```
$ olacvar webapi/staticdir
/olac/www/ss
```

Each function call is stored as follows.

Function call m1.m2...mK(a1,a2,..,aN) is transformed to a path m1/m2/.../mK/a1/a2/.../aN.txt. The intermediate directories are created under the $(olacvar webapi/staticdir) directory and aN.txt is created inside the aN-1 directory.

Function call m1.m2...mK() is transformed to a path m1/m2/.../mK.txt. The rest is the same as above.

For example, the result of nitems.byCountryCode('US') call can be accessed from the following URL:

```
http://www.language-archives.org/ss/nitems/byCountryCode/US.txt
```

Compare this to the srv.wsgi URL:

```
http://www.language-archives.org/srv/nitmes/byCountryCode/US
```


# How to add a new page #

# Process for creating static data files and JSON files #

# Discussion: why this approach #