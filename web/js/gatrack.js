// New asynchronous ga tracking code, replacing the old urchin.js.
//
// The original code can be found from the google analytics web site.
// - click "Analytics Settings"
// - locate website profile for www.l-a.org and click "Edit"
// - click "Check Status"
//
// To use, create the following <script> element as a subelement of the
// <head> element of the HTML page to be tracked.
//
//   <script type="text/javascript" src="/js/gatrack.js"> </script>
//

var gaurl = 'google-analytics.com/ga.js';
if (document.location.protocol == "https:") {
    gaurl = "https://ssl." + gaurl;
} else {
    gaurl = "http://www." + gaurl;
}

document.write('<script src="' + gaurl + '" type="text/javascript"></script>');

try {
    _gat._getTracker("UA-427085-3")._trackPageview();
} catch(err) {
    // ignore the error
}
