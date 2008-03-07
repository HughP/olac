import MySQLdb
import datetime
import re
import smtplib

template = """\
Dear OLAC participant,

You are receiving this email by virtue of your association with the following archive that participates in OLAC:

%(nameOfArchive)s

USAGE
These are the latest statistics on the usage of your metadata records on the OLAC site:

To be determined. Usage metrics not yet implemented.

QUALITY METRICS
OLAC tracks two metrics as primary indicators of overall metadata quality in its aggregated catalog: number of archives with fresh catalogs (that is, updated within the last 12 months) and number of archives with five-star metadata (that is, fully conforming to best practice as agreed on by the community). See http://www.language-archives.org/metrics/ for the current values of the metrics and a link to the document that explains them. The currency and quality scores for your archive are:

Last Updated: %(lastUpdated)s
Average Metadata Quality: %(starScore)d-star%(pluralStar)s (%(score).2f)

%(feedbackOnUpdate)s

COLLECTION METRICS
The following table reports the current metrics for the size, coverage, and cataloging of your collection. The final column reports the rank of your repository in comparison to all participants (where 1 is highest and %(numberOfArchives)d is lowest):

%(metricsTable)s

ARCHIVE DESCRIPTION
Please review your archive description at the following URL to ensure that all of the information you are supplying is up to date. Contact your OLAC system administrator (%(adminEmail)s) if you spot anything that should be changed:

http:/www.language-archives.org/archive/%(archiveId)s

Thank you for your participation.

Best wishes,
Steven & Gary

___
Steven Bird, University of Melbourne and University of Pennsylvania
Gary Simons, SIL International and GIAL
OLAC Coordinators (www.language-archives.org)
"""

metricsTemplate = """\
Metric                                Value   Rank
-----------------------------------   -----   ----
Number of Resources                   %5d   %4d
Number of Resources Online            %5d   %4d
Distinct Languages                    %5d   %4d
Distinct Linguistic Subfields         %5d   %4d
Distinct Linguistic Types             %5d   %4d
Distinct DCMI Types                   %5d   %4d
Average Elements Per Record           %5.1f   %4d
Average Encoding Schemes Per Record   %5.1f   %4d
"""

def generateMetricsTable(metrics, archiveId):
    """
    @param metrics: metrics table
    @param archiveId: sring archive id
    """
    row = metrics.findRow("RepositoryIdentifier", archiveId)
    fields = (
        "num_resources",
        "num_online_resources",
        "num_languages",
        "num_linguistic_fields",
        "num_linguistic_types",
        "num_dcmi_types",
        "avg_num_elements",
        "avg_xsi_types"
        )
    params = []
    for i in range(len(fields)):
        f = fields[i]
        v = row[f]
        params.append(v)
        params.append(metrics.rank(f,v))
    return metricsTemplate % tuple(params)

def determineFeedbackOnUpdate(lastUpdated, score, archiveId):
    """
    @param lastUpdated: yyyy-mm-dd
    @param score: ex) 0.74
    """
    feedback = []
    date = lastUpdated
    d = (date.today() - date).days / 365.25 * 12.0
    if d <= 12.0 and score >= 9.0:
        feedback.append("These metrics indicate that your archive is an exemplary member of the community. Congratulations!")
    if d > 12.0 and score >= 9.0:
        feedback.append("The quality of your metadata is exemplary. Congratulations!")
    if score < 7.0:
        feedback.append("Your average metadata quality could be improved.")
    if score >= 7.0 and score < 9.0:
        feedback.append("Your average metadata quality is good, but could still be improved.")
    if score < 9.0:
        feedback.append("See the metadata quality analysys of your sample record at the following URL for ideas on what could be done to improve the quality of your metadata.\n\nhttp://www.language-archives.org/sample/%s" % archiveId)
    if d > 12.0:
        feedback.append("Note that it is more than one year since your metadata repository was last updated; please update your repository at your earliest convenience.")
    if d <= 12.0 and d > 9:
        feedback.append("Note that it will soon be one year since your metadata repository was last updated; please update it by %s." % addMonths(lastUpdated, 12))

    return "\n\n".join(feedback)

def normalizeEmailAddress(s):
    s = re.sub(r"^mailto:", '', s)
    s = re.sub(r"[,; ].*", '', s)
    s = s.strip()
    return s

def composeEmail(metrics, archiveId):
    """
    @param metrics: metrics table
    @param archiveId: string archiveId
    """
    row = metrics.findRow("RepositoryIdentifier", archiveId)

    lastUpdated = row["last_updated"]
    score = row["metadata_quality"]
    starScore = int(score/2.0 + 0.5)
    pluralStar = ''
    if starScore > 1: pluralStar = 's'

    params = {
        "archiveId": archiveId,
        "nameOfArchive": row["RepositoryName"],
        "lastUpdated": lastUpdated,
        "score": score,
        "starScore": starScore,
        "pluralStar": pluralStar,
        "numberOfArchives": metrics.size(),
        "adminEmail": normalizeEmailAddress(row["AdminEmail"]),
        "feedbackOnUpdate": determineFeedbackOnUpdate(lastUpdated, score, archiveId),
        "metricsTable": generateMetricsTable(metrics, archiveId)
        }

    return template % params

def sendReport(msg, curatorName, curatorEmail, archiveId, isTest):
    """
    @param curatorName: curator name (ignored for now)
    """
    sender = "olac-admin@language-archives.org"
    curatorEmail = normalizeEmailAddress(curatorEmail)
    subject = "Archive Report for %s" % archiveId
    if isTest: subject = "(testing) " + subject
    msg = "From: %s\r\nTo: %s\r\nSubject: %s\r\n\r\n%s" % \
          (sender, curatorEmail, subject, msg)
    server = smtplib.SMTP('mail.ldc.upenn.edu')
    server.sendmail(sender, curatorEmail, msg)

class Metrics:
    def __init__(self):
        con = MySQLdb.connect(read_default_file="/ldc/home/olac/.my.cnf")
        cur = con.cursor(MySQLdb.cursors.DictCursor)
        cur.execute("select * from Metrics left join OLAC_ARCHIVE on Metrics.archive_id=OLAC_ARCHIVE.Archive_ID where Metrics.archive_id!=-1")
        self.metrics = cur.fetchall()
        cur.close()
        con.close()

    def findRow(self, field, value):
        for row in self.metrics:
            try:
                if row[field] == value:
                    return row
            except KeyError:
                # unknown database field
                return None

    def findCell(self, field, value, field2):
        row = self.findRow(field, value)
        if row:
            try:
                return row[field2]
            except KeyError:
                # unknown database field
                return None

    def getColumn(self, field):
        try:
            return [r[field] for r in self.metrics]
        except KeyError:
            # unknown field
            return None
    
    def size(self):
        return len(self.metrics)

    def rank(self, field, value):
        try:
            L = sorted([row[field] for row in self.metrics] + [value])
            L.reverse()
            return L.index(value) + 1
        except KeyError:
            # unknown field in row[field]
            return None

if __name__ == "__main__":
    import sys
    from optparse import OptionParser

    usage = """\
usage: %prog -h
       %prog [-s] [-t <email>] <OAI repository ID>
       %prog [-s] [-t <email>] -a"""
    op = OptionParser(usage)
    op.add_option("-a", "--all", dest="all",
                  action="store_true", default=False,
                  help="process all archives")
    op.add_option("-t", "--to", dest="receipient",
                  metavar="EMAIL",
                  help="specify receipient of reports; ignored unless -s option is used")
    op.add_option("-s", "--send", dest="send",
                  action="store_true", default=False,
                  help="send reports; by default they are printed on screen")

    opts, args = op.parse_args()

    def usage(msg):
        op.print_usage()
        print
        print msg
        print
        sys.exit(1)
        
    if opts.all == False:
        if len(args) != 1:
            usage("specify repository identifier")
        else:
            metrics = Metrics()
            archiveIds = [args[0]]
    else:
        metrics = Metrics()
        archiveIds = metrics.getColumn("RepositoryIdentifier")
    if opts.receipient:
        receipient = opts.receipient
    else:
        receipient = None   # the real curator email address is used
    sendemail = opts.send
    
    for archiveId in archiveIds:
        msg = composeEmail(metrics, archiveId)
        if sendemail:
            row = metrics.findRow('RepositoryIdentifier',archiveId)
            repoName = row["RepositoryName"]
            if receipient:
                sendReport(msg, row['Curator'], receipient, repoName, True)
            else:
                sendReport(msg, row['Curator'], row['CuratorEmail'], repoName, False)
        else:
            print "-" * 79
            print msg
            print
            
