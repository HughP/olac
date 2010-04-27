import olac
import lxml.etree
import simplejson as json

def getPolicies(*args, **kargs):
    """
    @return: A table of repository name and submission policy.
    """

    path = olac.olacvar('data/submission_policies')
    xml = lxml.etree.parse(path)
    L = []
    for policy in xml.xpath('//policy'):
        repo_name = policy.find('repositoryName').text
        repo_link = policy.find('link').text
        policy_text = policy.find('text').text
        L.append((repo_name, repo_link, policy_text))
    return json.dumps(sorted(L))

