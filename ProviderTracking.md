# Guidelines #

These are guidelines for using the issue tracker to document progress in OLAC participation for data providers. A distinction is made between tracking progress of work with archives who are already participating as data providers, and tracking progress of contact with archives who are potential participants.

## Existing providers ##

For an issue involving an existing data provider, create an issue of Type-Repository. The issue could be a defect to be fixed in the current implementation, the need for a complete re-implementation, or the need to upgrade from one OLAC version to another. (Note that Type-Defect is used only for defects in the infrastructure at language-archives.org, and not for defects in participating data providers.) The standard status sequence for software development is used:

  * **New** -- the implementation is newly proposed
  * **Accepted** -- it has been agreed that the issue should be fixed
  * **Dropped** -- it has been decided not to follow through on the issue
  * **Started** -- work has started
  * **Fixed** -- the issue has been resolved

By convention, issues involving the upgrade of a repository from version 1.0 to version 1.1 use a title beginning with "Upgrade:".

## Potential providers ##

In order to track the proposal that an identified archive should be encouraged and assisted to become an OLAC data provider, create an issue of Type-Provider. The completed status for one of this issues is Dropped or Done (rather than Fixed, since it is not a defect we are fixing).

  * **New** -- the issue identifies a potential OLAC participant
  * **Accepted** -- there is an email from the provider confirming their intention to participate in OLAC (specify date of email and surname of correspondent); add details about the implementation method, e.g. OLAC export, XML editor, scraping.
  * **Done** -- the repository is functioning and listed on the archives page
  * **Dropped** -- the provider has indicated that they do not want to participate, or we have given up after repeated attempts to make contact

Use comments appended to the issue to document significant events in the contact history, specifying date of email and surname of correspondent.