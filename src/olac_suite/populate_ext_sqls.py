import sys
import xml.parsers.expat
import urllib
import re
import codecs
encf, decf, reader, writer = codecs.lookup('UTF-8')

class ExpatHandlers:
    def StartElementHandler(self, tag, atts):
        pass
    
class Expat:
    def __init__(self, handlers=None):
        self._nsUriDict = {}
        self._prefixDict = {}
        self._parser = None
        if issubclass(handlers.__class__, ExpatHandlers):
            self._handlers = handlers
        else:
            self._handlers = ExpatHandlers()

    def getNamespaceUri(self, prefix):
        if prefix in self._nsUriDict:
            return self._nsUriDict[prefix][-1]
        else:
            return None

    def getNamespacePrefix(self, uri):
        if uri in self._prefixDict:
            return self._prefixDict[uri][-1]
        else:
            return None
    
    def _StartElementHandler(self, name, attr):
        # name = namespace_uri + ' ' + tagname
        tag = Tag(self, name)
        attrs = map(lambda x:Attribute(self,tag,x), attr.items())
        attrs = map(lambda x:(x.getName(),x), attrs)
        attrs = dict(attrs)

        ##
        ## Xinclude support
        ##
        if tag.getName() == 'include' and \
           tag.getNamespaceUri() == 'http://www.w3.org/2001/XMLSchema':
            if 'schemaLocation' in attrs:
                p = Expat(self._handlers)
                url = attrs['schemaLocation'].getValue()
                if url[:7] != 'http://':
                    url = self._parser.GetBase() + '/' + url
                p.parse(url)
        else:
            self._handlers.StartElementHandler(tag, attrs)

    def _EndElementHandler(self, name):
        tag = Tag(self,name)
        self._handlers.EndElementHandler(tag)

    def _CharacterDataHandler(self, s):
        self._handlers.CharacterDataHandler(s)
        
    def _StartNamespaceDeclHandler(self, prefix, uri):
        #print '+++',self,prefix,uri,self._nsUriDict
        try:
            self._nsUriDict[prefix].append(uri)
        except KeyError:
            self._nsUriDict[prefix] = [uri]
        try:
            self._prefixDict[uri].append(prefix)
        except KeyError:
            self._prefixDict[uri] = [prefix]

    def _EndNamespaceDeclHandler(self, prefix):
        #print '---',self,prefix, self._nsUriDict
        uri = self._nsUriDict[prefix][-1]
        self._nsUriDict[prefix].pop()
        self._prefixDict[uri].pop()


    def parse(self, url):
        # There seems to be no way to change the parser encoding setting
        # once the parser is created.  So, you need to check the document
        # encoding before creating the parser.
        f = urllib.urlopen(url)
        l = f.readline()
        while l:
            m = re.match(r"<\?\s*xml\s+(?:[^>]*\s+)?encoding\s*=\s*[\"']([^\"']+)[\"'].*",l)
            if m:
                enc = m.group(1)
                break
            l = f.readline()
        else:
            enc = 'UTF-8'
        f.close()

        # create parser
        f = urllib.urlopen(url)
        parser = xml.parsers.expat.ParserCreate(enc,' ')
        parser.StartElementHandler = self._StartElementHandler
        parser.EndElementHandler = self._EndElementHandler
        parser.CharacterDataHandler = self._CharacterDataHandler
        parser.StartNamespaceDeclHandler = self._StartNamespaceDeclHandler
        parser.EndNamespaceDeclHandler = self._EndNamespaceDeclHandler
        self._parser = parser

        i = url.rfind('/')
        self._parser.SetBase(url[:i])
        self._parser.ParseFile(f)
        
class Tag:
    def __init__(self, expat, s):
        # name = namespace_uri + ' ' + tagname
        self._ns_uri, self._tag = s.split()
        self._ns_prefix = expat.getNamespacePrefix(self._ns_uri)

    def __str__(self):
        if self._ns_prefix:
            return self._ns_prefix + ':' + self._tag
        else:
            return self._tag

    def getNamespacePrefix(self):
        return self._ns_prefix

    def getNamespaceUri(self):
        return self._ns_uri

    def getName(self):
        return self._tag

    
class Attribute:
    def __init__(self, expat, tag, name_val):
        # tag = Tag
        # name_val = (att_name, att_value)
        att,val = name_val
        if ':' in att:
            self._ns_prefix, self._att_name = att.split(':')
        else:
            self._ns_prefix = tag.getNamespacePrefix()
            self._att_name = att
        self._ns_uri = expat.getNamespaceUri(self._ns_prefix)
        self._att_value = val

    def __str__(self):
        if self._ns_prefix:
            return self._ns_prefix + ':' + self._att_name
        else:
            return self._att_name

    def getName(self):
        return self._att_name
    
    def getValue(self):
        return self._att_value

    def getNamespaceUri(self):
        return self._ns_uri

    def getNamespacePrefix(self):
        return self._ns_prefix



class MyHandlers(ExpatHandlers):
    def __init__(self):
        self._sh = []
        self._eh = []
        self._ch = []
        self._pushHandlers(self._Start,self._End,self._Char)

        self._ext = None
        self._ext_tag = None
        self._ext_char = None
        self._ext_transform = {'shortName':'Type',
                               'label':'Label',
                               'longName':'LongName',
                               'versionDate':'VersionDate',
                               'description':'Description',
                               'appliesTo':'AppliesTo',
                               'documentation':'Documentation'}
        
        self._code = None
        self._code_label = None
        self._codes = []

    def getResult(self):
        return (self._ext, self._codes)
    
    def _pushHandlers(self, sh, eh, ch):
        self._sh.append(sh)
        self._eh.append(eh)
        self._ch.append(ch)

    def _popHandlers(self):
        self._sh.pop()
        self._eh.pop()
        self._ch.pop()
        
    def StartElementHandler(self, tag, atts):
        tagnam = tag.getName()
        
        if tagnam == 'olac-extension':
            self._ext = {}
            self._pushHandlers(self._extStart, self._extEnd, self._extChar)
        elif tagnam == 'restriction':
            self._pushHandlers(self._codeStart, self._codeEnd, self._codeChar)
        else:
            self._sh[-1](tag, atts)

        

    def EndElementHandler(self, tag):
        tagnam = tag.getName()
        
        if tagnam == 'olac-extension':
            if 'Label' not in self._ext:
                self._ext['Label'] = self._ext['Type']
            self._popHandlers()
        elif tagnam == 'restriction':
            self._popHandlers()
        else:
            self._eh[-1](tag)

    def CharacterDataHandler(self, s):
        self._ch[-1](s)
        
    def _Start(self, tag, atts):
        pass
    def _End(self, tag):
        pass
    def _Char(self, s):
        pass
    
    def _extStart(self, tag, atts):
        self._ext_tag = tag.getName()
        self._ext_char = ''

    def _extEnd(self, tag):
        if self._ext_tag in self._ext_transform:
            k = self._ext_transform[self._ext_tag]
            if k in self._ext:
                self._ext[k] += ';' + self._ext_char
            else:
                self._ext[k] = self._ext_char
        self._ext_tag = None

    def _extChar(self, s):
        if self._ext_tag:
            self._ext_char += s

    def _codeStart(self, tag, atts):
        tagnam = tag.getName()
        if tagnam == 'enumeration':
            self._code = atts['value'].getValue()
        elif tagnam == 'documentation':
            self._code_label = ''
            
    def _codeEnd(self, tag):
        tagnam = tag.getName()
        if tagnam == 'enumeration':
            if self._code_label is None:
                label = self._code
            else:
                label = self._code_label
            self._codes.append((self._code, label))
            self._code = None
            self._code_label = None

    def _codeChar(self, s):
        if self._code_label is not None:
            self._code_label += s


extid = 1
out = writer(file('populate_ext.sql','w'))
for xsd in ('discourse-type',
            'language',
            'linguistic-field',
            'linguistic-type',
            'role'):
    url = "http://www.language-archives.org/OLAC/1.0/olac-%s.xsd" % xsd
    
    h = MyHandlers()
    parser = Expat(h)
    parser.parse(url)
    ext, codes = h.getResult()
    ext['DefiningSchema'] = url
    ext['NS'] = 'http://www.language-archives.org/OLAC/1.0/'
    ext['NSPrefix'] = 'olac'
    ext['NSSchema'] = 'http://www.language-archives.org/OLAC/1.0/olac.xsd'

    fields = ''
    values = ''
    for k,v in ext.items():
        v = re.sub(r'\s+',' ',v.strip())
        fields += '%s,' % k
        values += "'%s'," % v
    fields += 'Extension_ID'
    values += str(extid)

    out.write("insert into EXTENSION (")
    out.write(fields)
    out.write(") values (")
    out.write(values)
    out.write(");\n")

    for c,l in codes:
        out.write("insert into CODE_DEFN (Extension_ID,Code,Label) values (")
        out.write(str(extid))
        out.write(", '")
        out.write(c)
        out.write("', '")
        out.write(re.sub("'","''",l))
        out.write("');\n")

    extid += 1
