#!/bin/bash

sites=(
bufferzone.craveonline.com
www.comingsoon.net
www.craveonline.com
www.craveonlinemedia.com
www.hockeysfuture.com
www.hoopsvibe.com
home.springboardplatform.com
idly.craveonline.com
www.liveoutdoors.com
www.momtastic.com
www.playstationlifestyle.net
www.realitytea.com
ringtv.craveonline.com
www.shocktillyoudrop.com
www.superherohype.com
www.thefashionspot.com
www.totallyher.com
www.totallyhermedia.com
webecoist.momtastic.com
wholesomebabyfood.momtastic.com
www.wrestlezone.com
)

for i in "${sites[@]}"
do
   :
   /usr/bin/curl -sH "Host: $i" localhost/wp-cron.php
done
