var Cycler = (function (w, d, undefined) { // w == window && d == document
    var
    batchSize,
    urls,
    totalCycles,
    currCycleNum = 0,
    sites = [],
    dom = {
	prevSitesCycle: null,
	prevSitesUrls: null,
	currSitesCycle: null,
	currSitesUrls: null,
	nextSitesCycle: null,
	nextSitesUrls: null,
	// Events
	forwardSkip: null,
	backwardSkip: null,
	next: null,
    },
    events = {
	forwardSkip: function () {
	    var currUrls = urls.slice(batchSize * currCycleNum,
				      batchSize * currCycleNum + batchSize);

	    if (currCycleNum >= 0) {
		dom.backwardSkip.disabled
		    = false;

		dom.prevSitesCycle.innerHTML = "#" + currCycleNum;
		dom.prevSitesUrls.display(
		    urls.slice(batchSize * (currCycleNum - 1),
			       batchSize * (currCycleNum - 1) + batchSize));
	    }

	    dom.currSitesUrls.display(currUrls);

	    currCycleNum++;

	    updateCounter();
	    dom.currSitesCycle.innerHTML = "#" + currCycleNum;

	    if (currCycleNum >= totalCycles) {
		dom.forwardSkip.disabled
		    = dom.next.disabled
		    = true;

		dom.nextSitesCycle.innerHTML = "N/A";
		dom.nextSitesUrls.display([]);
	    }
	    else {
		dom.nextSitesCycle.innerHTML = "#" + (currCycleNum + 1);
		dom.nextSitesUrls.display(
		    urls.slice(batchSize * currCycleNum,
			       batchSize * currCycleNum + batchSize));
	    }

	    return currUrls;
	},
	backwardSkip: function () {
	    currCycleNum -= 2;

	    if (currCycleNum < 0) {
		dom.backwardSkip.disabled
		    = true;
	    }

	    dom.forwardSkip.disabled
		= dom.next.disabled
		= false;

	    return events.forwardSkip();
	},
	next: function () {
	    var urls = events.forwardSkip();

	    for (var i = 0; i < urls.length; ++i) {
		sites.push(w.open("http://" + urls[i], "_blank"));
	    }
	},
    },
    updateCounter = function () {
	d.getElementsByTagName("title")[0].innerHTML
	    = d.getElementById("counter").innerHTML
	    = "Cycle " + currCycleNum + " of " + totalCycles;
    },
    reminders = function () {
	var date = new Date();

	if (date.getDay() == 4) {
	    d.getElementById("weekly").style.display = "block";
	}

	if (date.getDate() == 1) {
	    d.getElementById("monthly").style.display = "block";
	}
    },
    init = function () {
	for (var id in dom) {
	    dom[id] = d.getElementById(id);

	    if (id.match(/SitesUrls$/)) {
		dom[id].display = function (urls) {
		    this.innerHTML = "";
		    for (var i = 0; i < urls.length; ++i) {
			this.innerHTML
			    += '<li><a href="http://' + urls[i] + '">'
			    + urls[i] + '</a></li>';
		    }
		};
	    }
	}

	for (var event in events) {
	    dom[event].addEventListener("click", events[event]);
	}

	dom.backwardSkip.disabled
	    = true;
	dom.forwardSkip.disabled
	    = dom.next.disabled
	    = false;

	updateCounter();

	dom.nextSitesUrls.display(urls.slice(batchSize * currCycleNum,
					     batchSize * currCycleNum
					     + batchSize));

	reminders();
    };

    return {
	start: function (option) {
	    batchSize = option.batchSize || 3; // Batch size defaults to 3
	    urls = option.urls;
	    totalCycles = Math.ceil((urls.length) / batchSize);

	    init();
	}
    };
})(window, document);
