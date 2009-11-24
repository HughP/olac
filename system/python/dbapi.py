"""
Synopsis
--------
Connection of useful functions for working with the OLAC database.


Error handling
--------------
We try to keep error handling minimal, none if possible. This helps us keep
the implementation of the API simple. Users should be prepared for unexplained
exceptions. Except for the cases of bugs, this API won't be the origin of the
exceptions.
"""

from olacvar import olacvar

def connectdb():
    """
    Connect to the OLAC MySQL database.

    @return: A dbapi2 connection object.
    """

    opts = {
        "host": olacvar("mysql/host"),
        "db": olacvar("mysql/olacdb"),
        "user": olacvar("mysql/user"),
        "passwd": olacvar("mysql/password"),
        "use_unicode": True,
        }
    
    return MySQLdb.connect(**opts)


def get_oai_repository_identifiers(con=None):
    """
    Returns a list of OAI repository identifiers. The list comes from the
    ARCHIVES table, i.e. from the registered repositories.

    @param con: Database connection object connected to the OLAC database. If
    None a new connection is made.
    @return: A generator of a string list.
    """

    if con is None:
        con = connectdb(err)
        
    cur = con.cursor()
    cur.execute("select distinct ID from ARCHIVES order by ID")
    for row in cur:
        yield row[0]


def get_olac_archive_id(oai_repo_id, con=None):
    """
    Return a numeric archive ID corresponding to the given OAI repository
    identifier. The result comes from the OLAC_ARCHIVE table. This means that
    None can be returned although the repository is registered, e.g. if the
    repository was never harvested.

    @param oai_repo_id: OAI repository identifier
    @param con: Database connection object connected to the OLAC database. If
    None a new connection is made.
    @return: A numeric archive ID. If there are more than one archives with the
    same OAI repository identifier, only one will be chosen randomly and
    returned. None is returned if such archive was not found in the database.
    """
    
    if con is None:
        con = connectdb(err)

    cur = con.cursor()
    cur.execute("select Archive_ID from OLAC_ARCHIVE "
                "where RepositoryIdentifier=%s",
                oai_repo_id)
    if cur.rowcount > 0:
        return cur.fetchone()[0]


