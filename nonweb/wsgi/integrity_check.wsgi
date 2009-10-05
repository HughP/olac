import MySQLdb
from olac import olacvar
from PyMeld import Meld
import re

class IntegrityPage:
    def __init__(self, environ, start_response):
        self.env = environ
        self.respond = start_response
        opts = {
            "host": olacvar('mysql/host'),
            "db": olacvar('mysql/olacdb'),
            "user": olacvar('mysql/user'),
            "passwd": olacvar('mysql/passwd'),
            }
        self.con = MySQLdb.connect(**opts)
        self.cur = self.con.cursor()

        # these are set by self.check_input()
        self.repo_id = None
        self.download = False

    def __iter__(self):
        if not self.check_input():
            yield self.forbidden()
            return

        sql = """
        select Archive_ID from OLAC_ARCHIVE where RepositoryIdentifier=%s
        """

        self.cur.execute(sql, self.repo_id)
        row = self.cur.fetchone()
        if row:
            archive_id = row[0]
        else:
            yield self.not_found()
            return

        sql1 = """
select
    Label, ic.Problem_Code, Severity, Value, ai.OaiIdentifier
from
    ARCHIVED_ITEM ai, METADATA_ELEM me,
    INTEGRITY_CHECK ic, INTEGRITY_PROBLEM ip
where
    ai.Archive_ID=%s and me.Item_ID=ai.Item_ID and
    ic.Problem_Code=ip.Problem_Code and
    ip.Applies_To='I' and ic.Object_ID=ai.Item_ID

union

select
    Label, ic.Problem_Code, Severity, Value, ai.OaiIdentifier
from
    ARCHIVED_ITEM ai, METADATA_ELEM me,
    INTEGRITY_CHECK ic, INTEGRITY_PROBLEM ip
where
    ai.Archive_ID=%s and me.Item_ID=ai.Item_ID and
    ic.Problem_Code=ip.Problem_Code and
    ip.Applies_To='E' and ic.Object_ID=me.Element_ID

order by Problem_Code
"""

        sql2 = """\
select
    Label, ic.Problem_Code, Severity, Value, Value
from
    INTEGRITY_CHECK ic, INTEGRITY_PROBLEM ip
where
    ic.Problem_Code=ip.Problem_Code and
    ip.Applies_To='A' and ic.Object_ID=%s
order by ic.Problem_Code
"""

        self.cur.execute(sql1, (archive_id, archive_id))
        tab1 = self.cur.fetchall()
        self.cur.execute(sql2, archive_id)
        tab2 = self.cur.fetchall()
        tab = tab1 + tab2

        errors = []
        warnings = []
        for row in tab:
            severity = row[2]
            if severity == 'E':
                errors.append(row)
            elif severity == 'W':
                warnings.append(row)

        if self.download:
            for element in self.displayAsTsv(errors, warnings):
                yield element
        else:
            for element in self.displayAsHtml(errors, warnings):
                yield element
        

    def check_input(self):
        args = self.env['PATH_INFO'].split('/')
        if len(args) == 2:
            repo_id = args[1]
            download = False
        elif len(args) == 3:
            repo_id = args[1]
            if args[2] == 'download':
                download = True
            else:
                return False
        else:
            return False
        
        if not repo_id:
            return False

        self.repo_id = repo_id
        self.download = download
        return True
        
    def forbidden(self):
        headers = [('Content-type','text/plain')]
        self.respond('403 Forbidden', headers)
        return '403 Forbidden'

    def not_found(self):
        headers = [('Content-type','text/plain')]
        self.respond('404 Not Found', headers)
        return '404 Not Found'

    def ok(self):
        headers = [('Content-type','text/plain')]
        self.respond('200 OK', headers)
        return '200 OK'

    def displayAsTsv(self, errors, warnings):
        filename = 'olac_integrity_checks-%s.tsv' % self.repo_id
        headers = [
            ('Content-type','text/tab-separated-values'),
            ('Content-Disposition','attachement; filename=%s' % filename),
            ]
        self.respond('200 OK', headers)
        
        for row in errors:
            yield "\t".join(row[1:5]) + "\r\n"
        for row in warnings:
            yield "\t".join(row[1:5]) + "\r\n"

    def displayAsHtml(self, errors, warnings):
        headers = [('Content-type','text/html')]
        self.respond('200 OK', headers)

        #base = get_base_dir(req)
        repoids = self.getArchivesList()

        template = olacvar('metrics/integrity_result_template')
        t = Meld(open(template).read().decode('utf-8'))

        if self.repo_id:
            s = "Use the following form to check other archives."
            t.repoid = ': ' + self.repo_id
        else:
            s = "Select an archive to check from the list and " \
                "click on the 'Submit Query' button."
        t.archive_selection_guide = s

        tmp = Meld("<option></option>")
        for rid in self.getArchivesList():
            opt = tmp.clone()
            opt.value = rid
            opt._content = rid
            if rid == self.repo_id:
                opt.selected = "selected"
            t.list += opt

        if not errors and not warnings:
            t.download_message = "There are no errors for this archive."
            
        else:
            s = '(Click <a href="%s/download">here</a> to download as a file.)'
            t.download_message = s % self.repo_id
            
            if errors:
                t.error_section += Meld("<h2>Errors:</h2>")
                t.error_section += Meld("""\
<p>The following errors have been detected in the metadata for this archive.
Their presence counts against the Overall Rating for the archive.</p>""")
                table = Meld('<table border="1"><tr><th>Error</th>' \
                             '<th>Offending Value</th>' \
                             '<th>Record ID</th></tr></table>')
                for error in errors:
                    row = Meld('<tr></tr>')
                    row += Meld('<td>%s</td>' % error[0])
                    if error[3]:
                        s = re.sub(r"((?:http|https|ftp)://\S+)",
                                   r'<a href="\1">\1</a>', error[3])
                        row += Meld('<td>%s</td>' % s)
                    else:
                        row += Meld('<td></td>')
                    row += Meld('<td><a href="/item/%s">%s</a></td>' % \
                                (error[4], error[4]))
                    table += row
                t.error_section += table

            if warnings:
                t.warning_section += Meld('<h2>Warnings:</h2>')
                t.warning_section += Meld("""\
<p>The following potential problems have been detected and should be looked
into. They are not severe enough to count against the archive's Overall
Rating.</p>""")
                table = Meld('<table border="1"><tr><th>Error</th>' \
                             '<th>Offending Value</th>' \
                             '<th>Record ID</th></tr></table>')
                for warning in warnings:
                    row = Meld('<tr></tr>')
                    row += Meld('<td>%s</td>' % warning[0])
                    if warning[3]:
                        s = re.sub(r"((?:http|https|ftp)://\S+)",
                                   r'<a href="\1">\1</a>', warning[3])
                        row += Meld('<td>%s</td>' % s)
                    else:
                        row += Meld('<td></td>')
                    row += Meld('<td><a href="/item/%s">%s</a></td>' % \
                                (warning[4], warning[4]))
                    table += row
                t.warning_section += table
                
        yield str(t)
        return
    
        t = Template(file=os.path.join(base,"templates/integrity_checks.tmpl"))
        t.repoid = repo_id
        t.errors = errors
        t.warnings = warnings
        t.repoids = repoids
        t.baseurl = '/' + os.path.basename(req.filename)
        req.content_type = 'text/html'
        req.send_http_header()
        req.write(str(t))
        return #apache.OK

    def getArchivesList(self):
        sql = """
        select RepositoryIdentifier from OLAC_ARCHIVE
        order by RepositoryIdentifier
        """
        self.cur.execute(sql)
        return [row[0] for row in self.cur.fetchall()]

application = IntegrityPage
