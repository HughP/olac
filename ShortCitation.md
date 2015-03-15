# Objective #

On the language index pages (and no doubt elsewhere), we need a short citation form for an item so that a user can skim the list of resources to spot ones of interest which can be inspected in full via a link to the /item page. ([Issue 79](https://code.google.com/p/olac/issues/detail?id=79))

On the item pages we need a short citation form to go at the bottom of the page with the search terms so that Google searches on the search terms will return something more useful. ([Issue 70](https://code.google.com/p/olac/issues/detail?id=70))

# Approach #

For the Google search application, a search hit for "iso639\_aaa" looks like this:

> _Ghotuo: a language of Nigeria_<br>
<blockquote>... oai:ethnologue.com:aaa. DateStamp: 2008-07-21. GetRecord: OAI-PMH request for<br>
simple  DC format. Search Info. Terms, dcmi_Text <b>iso639_aaa</b> iso639_eng.<br>
<a href='http://www.language-archives.org/item/oai:ethnologue.com:aaa'>http://www.language-archives.org/item/oai:ethnologue.com:aaa</a></blockquote>

The <br>
<br>
<dc:title><br>
<br>
 is already placed in the page title for the item page, so it already appears as the heading for a Google hit and we do not need to repeat it in our citation string. What we want to do is put something more useful in the second line, specifically the author, date, and publisher so that we get something more like this:<br>
<br>
<blockquote><i>Ghotuo: a language of Nigeria</i><br>
... Search Info. Citation: Gordon, Raymond G., Jr (editor). 2005. SIL International (www.sil.org). Terms: dcmi_Text <b>iso639_aaa</b> iso639_eng.<br>
<a href='http://www.language-archives.org/item/oai:ethnologue.com:aaa'>http://www.language-archives.org/item/oai:ethnologue.com:aaa</a></blockquote>

On the language index page, the same item could be represented as follows:<br>
<br>
<ul><li><i>Ghotuo: a language of Nigeria</i>. Gordon, Raymond G., Jr (editor). 2005. SIL International (www.sil.org). <a href='http://www.language-archives.org/item/oai:ethnologue.com:aaa'>oai:ethnologue.com:aaa</a></li></ul>

This is formed by making a list item of the dc:title (in italics), the short ciation string, and the OAI identifier as a link to the item page.<br>
<br>
<h1>Details</h1>

The short citation string has three parts, each of which is terminated by a period:<br>
<br>
<blockquote>Author(s). Date. Publisher.</blockquote>

The <b>author</b> part is formed as follows:<br>
<br>
<ul><li>If the record has a <br>
<br>
<dc:creator><br>
<br>
 element, return the contents of all all creator elements separated by semicolon and space;<br>
</li><li>Else if the record has <br>
<br>
<dc:contributor><br>
<br>
 element with <code>olac:code="author"</code>, return the contents of all contributor elements where <code>olac:code="author"</code> separated by semicolon and space;<br>
</li><li>Else return the contents of all contributor elements with the role code following in parenthesis and individual contributors separated by semicolon and space.</li></ul>

We can dispense with putting the role of non-authors in parentheses if that seems excessively costly in terms of implementation.<br>
<br>
<br>
The <b>date</b> part is formed as follows:<br>
<br>
<ol><li>Find the DC dumbed-down date string following the order of element preference given in section 1 of <a href='http://olac.wiki.sourceforge.net/Display+format+and+DC+crosswalk'>http://olac.wiki.sourceforge.net/Display+format+and+DC+crosswalk</a>
</li><li>If none of the date elements are present, return "n.d."<br>
</li><li>If the date string contains a hyphen, return everything up to the first hyphen; otherwise return the full date string.</li></ol>


The <b>publisher</b> part is formed as follows:<br>
<br>
<ul><li>If the record has <br>
<br>
<dcterms:bibliographicCitation><br>
<br>
, return its contents;<br>
</li><li>Else if the record has <br>
<br>
<dc:publisher><br>
<br>
, return its contents;<br>
</li><li>Else return the name of the archive that published the record.