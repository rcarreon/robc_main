var AutoCycler = (function (w, d, $, undefined) {
    var
    urls, // Array which contains the URLs of the sites to cycle.
    currUrlNum, // Index of the previous array.
    height, // Height of the iframe which displays the sites.
    nextSiteSecs, // Wait time to start over a new cycle.
    delay, // The time it takes for a site to begin scrolling down.
    scrollDuration, // How much it takes to scroll the page from start to end.
    /**
     * Gets the next cycleable site to cycle, displays and scrolls it; then
     * it calls itself again to begin anew.
     *
     * A cycleable site is any site not listed in the "excluded" array.
     *
     * When it runs out of sites, resets "currUrlNum" to zero and goes all
     * over the sites from the beginning.
     */
    nextSite = function () {
	var currUrl = (excluded.indexOf(urls[currUrlNum]) == -1)
	    ? urls[currUrlNum]
	    : urls[++currUrlNum];

        $("#showframe")
	    .attr("src", "http://" + currUrl)
	    .attr("height", height);
        $("html, body")
	    .stop(true)
	    .animate({scrollTop:0}, 0)
	    .delay(delay)
	    .animate({scrollTop: height}, scrollDuration);

        d.title = "Cycler: " + (currUrlNum++) + ": " + currUrl;

	if (currUrlNum >= urls.length) {
	    currUrlNum = 0;
	}

	setTimeout(nextSite, nextSiteSecs);
    },
    /**
     * Prevents a wild iframe to take over current window.
     */
    frameBusterBuster = function () {
	var
	preventBust = 0,
	status204Location
	    = "http://"
	    + w.location.host
	    + "/files/cycler/204.php";

	w.onbeforeunload = function () {
	    preventBust++;
	};

	setInterval(function () {
	    if (preventBust > 0) {
		preventBust -= 2;
		w.top.location = status204Location;
	    }
	}, 1);
    },
    // Sites which won't work with the auto cycler for various reasons
    excluded = [
	// HTTP authentication prompt can't be disabled by conventional means
	"admin.sherdog.com"
    ];

    return {
	start: function (option) {
	    urls = option.urls;

	    // Apply default values whenever possible.
	    currUrlNum = 0;
	    height = option.height || 3500;
	    nextSiteSecs = option.nextSiteSecs || 15000;
	    delay = option.delay || 5000;
	    scrollDuration = option.scrollDuration
		|| (nextSiteSecs - nextSiteSecs / 3);

	    if (new Date().getDay() == 5) {
		urls.push("beer30.gnmedia.net");
	    }

	    frameBusterBuster();
	    nextSite();
	}
    };
})(window, document, jQuery);
