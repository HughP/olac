var SubmissionPolicies = new function() {

    // private

    function download(url, callback) {
	var xhr = new XMLHttpRequest;
	xhr.onreadystatechange = function(event) {
	    if (this.readyState == XMLHttpRequest.DONE) {
		var tab = eval('(' + this.responseText + ')');
		callback(tab);
	    }
	}
	xhr.open("GET", url);
	xhr.send();
    }

    // public

    this.displayPolicies = function(elementid) {
	var display = function(tab) {
	    var container = document.getElementById(elementid);
	    for (var i=0; i < tab.length; ++i) {
		var name = document.createElement('p');
		var policy = document.createElement('blockquote');
		name.innerHTML = tab[i][0];
		policy.innerHTML = tab[i][1];
		container.appendChild(name);
		container.appendChild(policy);
	    }
	}
	download('/srv/submissionPolicies/getPolicies', display);
    }

    // initialization

    this.init = function(elementId) {
	SubmissionPolicies.displayPolicies(elementId);
    }
}
