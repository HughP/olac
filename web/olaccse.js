// OLACSearch class
// @param searchBoxId: The ID of a container to hold the search control.
// @param resultBoxId: The ID of a container to hold the search results.
// @param areaSelectorId: The ID of a container to hold the area dropdown.
// @param archiveSelectorId: The ID of a container to hold the archive dropdown.
function OLACSearch(searchBoxId,
		    resultBoxId,
		    areaSelectorId,
		    archiveSelectorId)
{
    this.searchBox = document.getElementById(searchBoxId);
    this.resultBox = document.getElementById(resultBoxId);
    this.areaSelector = document.getElementById(areaSelectorId);
    this.archiveSelector = document.getElementById(archiveSelectorId);

    this.searcher = new google.search.WebSearch();
    this.searcher.setSiteRestriction('008121384105191196936:y5ywkrnqcto');
    this.searcher.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
    this.gsForm = new google.search.SearchForm(false, this.searchBox);

    this.searcher.setSearchCompleteCallback(this, this.onSearchComplete);
    this.gsForm.setOnSubmitCallback(this, this.onSubmit);

    Ext.get(this.resultBox).on('click', this.onPageIndexClicked, this);
    this.initializeArchivesSelector();
}

OLACSearch.prototype.initializeArchivesSelector = function()
{
    var ajaxopts = {
	url: '/cp/ajax/db/getRegisteredRepositoryIdentifiers',
	success: function(o, opts) {
	    var list = eval('(' + o.responseText + ')');
	    var sel = Ext.get(this.archiveSelector);
	    for (var i=0; i<list.length; ++i) {
		var espec = {tag:'option', html:list[i], value:list[i]};
		sel.createChild(espec);
	    }
	},
	failure: function(o, opts) {
	    alert('failed to obtain archives list');
	},
	scope: this
    }
    Ext.Ajax.request(ajaxopts);
}

OLACSearch.prototype.onPageIndexClicked = function(event, target)
{
    if (Ext.get(target).hasClass('pageindex')) {
	var page = target.firstChild.nodeValue - 1;
	this.searcher.gotoPage(page);
    }
}

OLACSearch.prototype.onSubmit = function(form)
{
    var extraterms = '';
    // obtain search terms for selected area
    var areaidx = this.areaSelector.selectedIndex;
    if (areaidx != 0) {
	extraterms += this.areaSelector[areaidx].value + " ";
    }

    // obtain search terms for selected archive
    var archiveidx = this.archiveSelector.selectedIndex;
    if (archiveidx != 0) {
	extraterms += this.archiveSelector[archiveidx].value + " ";
    }

    this.searcher.setQueryAddition(extraterms);

    var query = form.input.value;
    this.searcher.execute(query);
    return false;
}

OLACSearch.prototype.onSearchComplete = function()
{
    // Clean up whatever remaining inside the result box. (Note that search
    // results have alreay been cleaned up by google api at this point.)
    Ext.DomHelper.overwrite(this.resultBox,'');

    for (var i=0; i<this.searcher.results.length; ++i) {
	var r = this.searcher.results[i];
	this.resultBox.appendChild(r.html);
    }

    if ('cursor' in this.searcher) {
	var cursor = this.searcher.cursor;
	var pages = cursor.pages;
	var cp = cursor.currentPageIndex; // begins from 0
	for (var i=0; i<pages.length; ++i) {
	    var p = pages[i];
	    var spec = {tag:'div', cls:'pageindex', html:p.label};
	    var node = Ext.DomHelper.append(this.resultBox, spec, true);
	    if (i == cp) {
		node.addClass('pageindex-current');
	    }
	}
    }
    else {
	var spec = {tag:'div', html:'No records found'};
	Ext.DomHelper.append(this.resultBox, spec);
    }
}

function initialize() {
    olacsearch = new OLACSearch('search-box', 'result-box',
				'area-selector', 'archive-selector');
}

google.load("search", "1");
google.load("ext-core", "3.0.0");
google.setOnLoadCallback(initialize);