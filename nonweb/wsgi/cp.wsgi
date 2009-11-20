import os
import olac
os.environ['PYTHON_EGG_CACHE'] = olac.olacvar('python/egg_cache/wsgi')

import cherrypy
import MySQLdb
import simplejson


def connectdb():
    return MySQLdb.connect(
        host = olac.olacvar('mysql/host'),
        db = olac.olacvar('mysql/olacdb'),
        user = olac.olacvar('mysql/user'),
        passwd = olac.olacvar('mysql/passwd'),
        use_unicode = True
        )

def json_encode(*args, **kwargs):
    response = cherrypy.response
    response.headers['Content-Type'] = 'application/json'
    response.body = simplejson.JSONEncoder().iterencode(response.body)

cherrypy.tools.json = cherrypy.Tool('before_finalize',json_encode,priority=30)


class Root:
    @cherrypy.expose
    def index(self):
        return "Hello, World"

class Ajax:
    pass


class Survey:
    """
    API functions for the survey page.
    """
    
    @cherrypy.expose
    @cherrypy.tools.json()
    def element(self, id):
        sql = """
        select count(*) Freq, Lang, Type, Code, Content
        from METADATA_ELEM where Tag_ID = %s
        group by Content, Lang, Type, Code
        order by Freq desc
        """
        con = connectdb()
        cur = con.cursor(MySQLdb.cursors.DictCursor)
        cur.execute(sql, id)
        return cur.fetchall()

    @cherrypy.expose
    @cherrypy.tools.json()
    def recordids(self, lang=None, type=None, code=None, content=None,
                  langNull=None, typeNull=None, codeNull=None,
                  contentNull=None):
        def f(name, isnull, value, cond, args):
            field_name = 'me.%s' % name.capitalize()
            if isnull == 'true':
                cond.append('%s is null' % field_name)
            else:
                cond.append('%s = %%s' % field_name)
                args.append(value)
        cond = []
        args = []
        f('lang', langNull, lang, cond, args)
        f('type', typeNull, type, cond, args)
        f('code', codeNull, code, cond, args)
        f('content', contentNull, content, cond, args)
        sql = """
        select distinct OaiIdentifier
        from ARCHIVED_ITEM ai, METADATA_ELEM me
        where ai.Item_ID=me.Item_ID and %s
        order by OaiIdentifier
        """ % " and ".join(cond)
        con = connectdb()
        cur = con.cursor()
        cur.execute(sql, args)
        return cur.fetchall()


class GeneralDatabaseAPI:

    @cherrypy.expose
    @cherrypy.tools.json()
    def getRegisteredRepositoryIdentifiers(self, *args, **kwargs):
        sql = "select distinct ID from ARCHIVES order by ID"
        con = connectdb()
        cur = con.cursor()
        cur.execute(sql)
        return [x[0] for x in cur.fetchall()]


root = Root()
root.ajax = Ajax()
root.ajax.survey = Survey()
root.ajax.db = GeneralDatabaseAPI()

application = cherrypy.tree.mount(root,"/cp")

