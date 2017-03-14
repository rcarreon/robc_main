#!/bin/bash

echo -e "############################################"
echo -e "#### Creating List #########################"
echo -e "############################################"
echo -e ""

ip=$(hostname  -I | cut -f1 -d' ')

sites=(afterellen.com
       base.evolvemediallc.com
       bufferzone.craveonline.com
       beautyriot.com
       cattime.com
       comingsoon.net
       craveonline.com
       craveonline.ca
       craveonline.com.au
       craveonline.co.uk
       craveonlinemedia.com
       dogtime.com
       evolvemediallc.com
       hockeysfuture.com
       home.springboardplatform.com
       hoopsvibe.com
       idly.craveonline.com
       idontlikeyouinthatway.com
       liveoutdoors.com
       momtastic.com
       momtastic.com.au
       mostcraved.craveonline.com
       mumtasticuk.co.uk
       musicfeeds.com.au
       pbwp.gnmedia.net
       playstationlifestyle.net
       forums.playstationlifestyle.net
       realitytea.com
       ringtv.craveonline.com
       sherdog.com
       forums.sherdog.com
       admin.sherdog.com
       fightfinder.com
       ropeofsilicon.com
       shocktillyoudrop.com
       spidermanhype.com
       spikedhumor.com
       superherohype.com
       thefashionspot.com
       thefashionspot.ca
       thefashionspot.com.au
       thefashionspot.co.uk
       totallyher.com
       totallyhermedia.com
       totallyhermedia.com.au
       totallyhermedia.co.uk
       totallyhermedia.ca
       totallykidz.com
       webecoist.momtastic.com
       wholesomebabyfood.momtastic.com
       wrestlezone.com
       studio.musicfeeds.com.au
       awards.totalbeauty.com
       mandatory.com
       )

for i in "${sites[@]}"
    do
    echo -e "#### $i"
    echo -e "$ip sbx.$i"
    echo -e "$ip cdn-sbx.$i"
    echo -e "$ip cdn1-sbx.$i"
    echo -e "$ip cdn2-sbx.$i"
    echo -e "$ip cdn3-sbx.$i"
    echo -e "$ip sbx.m.$i"
    echo -e "$ip sbb.$i"
    echo -e "$ip cdn-sbb.$i"
    echo -e "$ip cdn1-sbb.$i"
    echo -e "$ip cdn2-sbb.$i"
    echo -e "$ip cdn3-sbb.$i"
    echo -e "$ip sbb.m.$i"
    echo -e ""
    done

echo -e ""
echo -e "############################################"
echo -e "#### List Complete #########################"
echo -e "############################################"

echo -e ""
echo -e ""
echo -e "Copy and Paste the generated list above into your desktop's host file"
