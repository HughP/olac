// OLACSearch class
// @param searchBoxId: The ID of a container to hold the search control.
// @param resultBoxId: The ID of a container to hold the search results.
// @param areaSelectorId: The ID of a form containing radio buttons named area.
// @param archiveSelectorId: The ID of a container to hold the archive dropdown.
// @param extraterms: Search terms that are added to every search query.
// @param areaname: If specified, corresponding region is selected from the map.
// @param query: If specified, the query if submitted after initialization.
// @param archiveid: If specified, corresponding archive is selected from
//   the selector.
function OLACSearch(searchBoxId,
		    resultBoxId,
		    areaSelectorId,
		    archiveSelectorId,
		    extraterms,
		    areaname,
		    query,
		    archiveid)
{
    this.searchBox = document.getElementById(searchBoxId);
    this.resultBox = document.getElementById(resultBoxId);
    this.areaSelector = document.getElementById(areaSelectorId);
    this.archiveSelector = document.getElementById(archiveSelectorId);

    this.extraterms = "";
    if (extraterms) {
	this.extraterms = extraterms;
    }

    this.areaname = areaname;
    this.defaultArchiveId = archiveid;

    function area_enter_handler_closure(name, scope) {
	return function(event) {
	    scope.enterRegion.call(scope, name);
	}
    }
    function area_exit_handler_closure(name, scope) {
	return function(event) {
	    scope.exitRegion.call(scope, name);
	}
    }
    function area_click_handler_closure(name, scope) {
	return function(event) {
	    scope.clickRegion.call(scope, name);
	}
    }

    var areas = ['africa','americas','asia','europe','pacific'];
    for (var i=0; i<areas.length; i++) {
	var el = $('area-' + areas[i]);
	el.addEvent('mouseover', area_enter_handler_closure(areas[i], this));
	el.addEvent('mouseout', area_exit_handler_closure(areas[i], this));
	el.addEvent('click', area_click_handler_closure(areas[i], this));
    }

    this.searcher = new google.search.WebSearch();
    this.searcher.setSiteRestriction('008121384105191196936:y5ywkrnqcto');
    this.searcher.setResultSetSize(google.search.Search.FILTERED_CSE_RESULTSET);
    this.gsForm = new google.search.SearchForm(false, this.searchBox);

    this.searcher.setSearchCompleteCallback(this, this.onSearchComplete);
    this.gsForm.setOnSubmitCallback(this, this.onSubmit);

    function nav_handler_closure(scope) {
	// @param scope: The object to be prepended to the scope chain.
	return function(event) {
	    scope.onPageIndexClicked.call(scope, event);
	}
    }

    $(this.resultBox).addEvent('click', nav_handler_closure(this));
    this.initializeArchivesSelector();

    if (query) {
	$(this.searchBox).getElement("input[name=search]").value = query;
	this.search(query, this.defaultarchiveId);
    }
}

OLACSearch.prototype.initializeArchivesSelector = function()
{
    var xhr = new XMLHttpRequest;
    xhr.scope = this;
    xhr.onreadystatechange = function(event) {
	if (this.readyState == XMLHttpRequest.DONE) {
	    var list = eval('(' + this.responseText + ')');
	    for (var i=0; i<list.length; ++i) {
		var slong = list[i][1];
		var s = slong;
		if (s.length > 36) {
		    s = s.substr(0,36) + '...';
		}
		var opt = new Option(s, list[i][0], false,
				     list[i][0]==this.scope.defaultArchiveId);
		opt.setAttribute('title', slong);
		this.scope.archiveSelector.options[i+1] = opt;
	    }
	}
    }
    xhr.open("GET", "/cp/ajax/db/getActiveRepositories");
    xhr.send();
}

OLACSearch.prototype.onPageIndexClicked = function(event)
{
    var target = $(event.target);
    var classValue = target.get('class');
    if (classValue != null) {
	var values = classValue.split();
	for (var i=0; i<values.length; ++i) {
	    if (values[i] == 'pageindex') {
		var page = target.get('text') - 1;
		this.searcher.gotoPage(page);
		break;
	    }
	}
    }
}

OLACSearch.prototype.onSubmit = function(form)
{
    var extraterms = this.extraterms + ' ';
    // obtain search terms for selected area
    //for (var i=0; i<this.areaSelector.area.length; i++) {
    //if (this.areaSelector.area[i].checked == true)
    //    extraterms += this.areaSelector.area[i].value + " ";
    //}

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

OLACSearch.prototype.search = function(query, repoid)
{
    if (repoid)
	this.searcher.setQueryAddition(repoid);
    this.searcher.execute(query);
}

OLACSearch.prototype.onSearchComplete = function()
{
    // Clean up whatever remaining inside the result box. (Note that search
    // results have alreay been cleaned up by google api at this point.)
    this.resultBox.innerHTML = '';
    $(this.resultBox).grab(new Element('hr'));

    for (var i=0; i<this.searcher.results.length; ++i) {
	var r = this.searcher.results[i];
	this.resultBox.appendChild(r.html);
    }

    if ('cursor' in this.searcher) {
	var cursor = this.searcher.cursor;
	var pages = cursor.pages;
	var cp = cursor.currentPageIndex; // begins from 0
	var center = new Element('center');
	center.inject(this.resultBox);
	for (var i=0; i<pages.length; ++i) {
	    var atts = {'class':'pageindex', 'html':pages[i].label}
	    var node = new Element('div', atts);
	    node.inject(center);
	    if (i == cp) {
		node.addClass('pageindex-current');
	    }
	}
    }
    else {
	var node = new Element('div', {html:'No records found'});
	node.inject(this.resultBox);
    }

    $(this.resultBox).grab(new Element('hr'));
}

OLACSearch.prototype.enterRegion = function(name)
{
    $('world-map').set('src','/images/world-color-' + name + '-320.png');
}

OLACSearch.prototype.exitRegion = function(name)
{
    var img = '/images/world-color-320.png';
    if (this.areaname) {
	img = '/images/world-color-' + this.areaname + '-320.png';
    }
    $('world-map').set('src', img);
}

OLACSearch.prototype.clickRegion = function(name)
{
    window.location = '/area/' + name;
}

    function initialize(extraterms, areaname, query, archiveid)
{
    // extraterms: a space separated string containing extra search terms
    olacsearch = new OLACSearch('search-box',
				'result-box',
				'areas',
				'archive-selector',
				extraterms,
				areaname,
				query,
				archiveid);
}

google.load("search", "1");
google.load("mootools", "1.2.4");
