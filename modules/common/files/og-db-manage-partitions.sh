#!/bin/bash
sudo -u mysql /usr/bin/perl /usr/local/bin/db-manage-partition.pl $(date +"%Y-%m-%d" --date="1 year") sql1v-origin.og.stg.lax.gnmedia.net  origintech@evolvemediallc.com ""
sudo -u mysql /usr/bin/perl /usr/local/bin/db-manage-partition.pl $(date +"%Y-%m-%d" --date="1 year") VIP-SQLRW-ORIGIN.OG.PRD.LAX  origintech@evolvemediallc.com ""
