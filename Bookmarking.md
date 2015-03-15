# Social Bookmarking as a Strategy within the OLAC #
# Infrastructure #

We could use a social bookmarking tool to implement a number of services within our infrastructure:
  * [Maintaining a list of potential participants](Bookmarking#Listing_potential_participants.md)
  * [Identifying language resources and creating minimal metadata for precise search](Bookmarking#Identifying_language_resources.md)
  * [Tracking peer review of metadata submitted by participants](Bookmarking#Tracking_peer_review.md)

## Choosing a tool ##

For our purposes we need a tool that supports at least these features:
  * Tagging
  * A URL-based API that can return XML responses (so that we can build services at our site)
  * (Are there other must-have features?)
The Wikipedia page on [Social Bookmarking](http://en.wikipedia.org/wiki/Social_bookmarking) links to a number of tools in the genre. The two best-known members of the family appear not to meet the minimal requirements: **del.icio.us** has an [API](http://del.icio.us/help/api/) that returns XML but it appears to query only one's own posts and **Digg** does not support tagging. [Connotea](http://www.connotea.org/) is a social bookmarking tool designed specifically for the scientific community and it has the two needed features. Thus we have started experimenting with it. (Should we look into other tools as well?)

## Listing potential participants ##

Social bookmaking might be a good way to create our list of potential participants for objective 1.2 of the project. We could agree on a set of tags, then anyone involved in the project could add to the list anytime they run into something interesting while browsing the web. If it works well, we could even open it up to the entire OLAC community, specifying a means for anybody to add something to the list.

So what tags do we need for this purpose? These are proposed:
  * olac\_prospect — Marks the home page for an institution that holds language resources offline or for a web site that offers them online
  * olac\_prospects — Marks a page that gives links to a number of potential OLAC prospects
  * archive — An additional tag used with a prospect that is an archive that collects and curates language resources

Using Connotea, this URL yields a page of all bookmarks for olac\_prospect:
> http://www.connotea.org/tag/olac_prospect<br>
and this URL returns an XML response:<br>
<blockquote><a href='http://www.connotea.org/data/tag/olac_prospect'>http://www.connotea.org/data/tag/olac_prospect</a><br></blockquote>

The URL queries use + as an AND operator, so we could also define tags for tracking the process of contacting the potential participants and encouraging them to join, and then query just for sites in a particular stage of the process.<br>
<br>
<h2>Identifying language resources</h2>

Social bookmarking might be a way to implement a very "low bar" approach for entering the OLAC catalog. It would not only be a way for the owner of a set of resources to catalog them, but also a way for the project's Research Assistant to catalog the resources at a site of interest and indeed for anybody to do the same.<br>
<br>
Connotea captures a title and description. We can add precise metadata by means of tags that have namespace prefixes, e.g. olac<i>, iso639</i>, iso3166<i>, dcmi</i>.<br>
<br>
For instance, using Connotea this URL yields a page of all resources tagged for the Sikaiana language:<br>
<blockquote><a href='http://www.connotea.org/tag/iso639_sky'>http://www.connotea.org/tag/iso639_sky</a><br>
and this URL returns an XML response:<br>
<a href='http://www.connotea.org/data/tag/iso639_sky'>http://www.connotea.org/data/tag/iso639_sky</a><br>
It is also possible to download tagged pages in a MODS format:<br>
<a href='http://www.connotea.org/mods/tag/iso639_sky'>http://www.connotea.org/mods/tag/iso639_sky</a><br></blockquote>

These examples did not use a tag to identify the page as an olac_resource, but we probably need that in order to harvest all posts for olac resources. Note that the Connotea API also retrieves by date, so that it would be possible to implement incremental harvesting.<br>
<br>
<h2>Tracking peer review</h2>

One of the OLAC core values is peer review. We have always contemplated a system for supporting peer review of the metadata supplied by participating archives. Social bookmarking might offer a way to do that. The page being tagged would be the /item/id page on the OLAC site.