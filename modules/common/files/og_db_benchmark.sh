#!/bin/bash
sudo -u mysql /usr/bin/perl /usr/local/bin/og_db_benchmark_report.pl $(date +"%Y-%m-%d" --date="-1 month") sql1v-bd.og.prd.lax.gnmedia.net origintech@evolvemediallc.com
