#!/bin/bash

# data retention policy for data files in crowdignite's /app/data share

TYPE=$(uname -n | cut -d. -f1 | cut -d- -f2-)
CLASS=$(uname -n | cut -c 1-3)

case $TYPE in
    vw) 
        # keep a day of consolidated files
        find /app/data/vwinput* -mtime +0 -type f -iname 'vwConsWidget.*' -delete
        # keep a week of models
        find /app/data/vwmodels* -mtime +7 -type f -iname '*.model' -delete
        ;;  
    ci) 
        # keep a week of vwlogs
        find /app/data/vwlogs -mtime +7 -type f -delete
        ;;  
    *)  
        echo default case... what server is this?? do I have a data share??
        ;;  
esac
