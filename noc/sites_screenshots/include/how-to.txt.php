<?php
/*
 To update the id-sites.txt file, just execute the following lines one by one

 export RTUSER='root'
 export RTPASSWD='password'
 export RTSERVER='http://inventory.gnmedia.net'
 rt list -t asset "Type = 'Site' AND Status = 'production' AND CF.{MonitorPriority} = 'High'" >> id-sites.txt

 comments were put intentionally inside php to avoid not authorized people read this information
 by http accidentally


*******************
 remember to rename a file with the next name convention
 
 id-size-mmddyy-description.jpg
 
  where:
 id = id of the site in inventory, you can check the id in the file "id-sites.txt"
 size = desktop, tablet, mobile. (for future usage). Default value should be desktop
 mmddyy = date of the last update, just numbers in MonthDayYear format.
 description = the name of the file, this name will not be used, is just to have human readability
		in the filename

 if you don't have something to put, avoid just omit the argument, instead, add something like "none",
 and also don't forget to add the dash "-" to in the name convention, it is used for php to create the page
 in a kind of dinamic way
 
*******************

*/
?>
