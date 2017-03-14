#!/bin/sh
#
# Script that generates html file containing pingdom list of sites for the auto scrolling visual check
#

AUTO_FILENAME="auto_site_mon.html"

# Variable that will hold pingdom sites list
PINGDOM_SITES=`curl -H "Authorization: Basic VGVjaG5vbG9neXBsYXRmb3JtQGdvcmlsbGFuYXRpb24uY29tOk5AZ2lvNUI0"  -H "App-Key:000mhi2gky9570lx6clk2y6uh412tgdy" -G "https://api.pingdom.com/api/2.0/checks" | tr , '\n' | grep hostname | sed -e 's/^"hostname":"//g' -e 's/.$//g'`

# Variable that holds the top html code
HTML_TOP="
<html>
    <head>
        <meta http-equiv="refresh" content="2610;url=auto_site_mon.html">
        <meta http-equiv=\"Cache-control\" content=\"no-cache\">
        <meta http-equiv=\"expires\" content=\"-1\">

        <style type=i\"text/css\">
            body {padding: 0; margin: 0;}
        </style>
        <script type=\"text/javascript\" src=\"http://code.jquery.com/jquery-1.8.2.min.js\"></script>
        <script type=\"text/javascript\">

       
            var currentUrl = false;
            var nextpagesecs = 15000;
            var url = 0;

            // Add new URLs here...
            var urls = [

"

# Variable to hold the sites list plus come code around them
HTML_MID=`echo "$PINGDOM_SITES" | sed -e "s|^|[\'http://|g" -e "s|$|\', 3500],|g"`

# Here we are just scrubbing out a couple of sites that pop us out of the cycler on the browser
HTML_MID=`echo "$HTML_MID" | egrep -v "www\.babyandbump\.com|www\.drinksmixer\.com|www\.springboardplatform\.com"`

# Variable that holds the bottom html code
HTML_BOT="
];

            function nextpage() {
                currentUrl = urls[url];
                if (!currentUrl) {
                    \$('html, body').stop(true).animate({scrollTop:0}, 0);
                    window.location.reload(true);
                } else {
                    \$(\"#showframe\").attr('src', currentUrl[0]).attr('height', currentUrl[1]);
                    \$('html, body').stop(true).animate({scrollTop:0}, 0).delay(5000).animate({scrollTop: currentUrl[1]}, 10000);
                    document.title = 'Cycler: ' + (url++) + ': ' + currentUrl[0];
                    setTimeout(\"nextpage()\", nextpagesecs);
                }
                
            }
       
      </script>
      </head>

    <body onload=\"javascript:nextpage(); return false;\">
        <iframe id=\"showframe\" frameborder=\"0\" scrolling=\"no\" marginwidth=\"0\" marginheight=\"0\" width=\"100%\" height=\"3500px\" style=\"padding: 0; margin: 0; border: 0;\">
            <p>Your browser does not support iframes.</p>
        </iframe>
    </body>

 </html>"


# Putting it all together in one html file
echo "$HTML_TOP" "$HTML_MID" "$HTML_BOT" > ${AUTO_FILENAME}

echo -e "***\nDone!\nGenerated file is ${AUTO_FILENAME}"

