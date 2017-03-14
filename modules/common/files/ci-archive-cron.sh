#!/bin/bash
sudo -u mysql /usr/bin/perl /usr/local/bin/db-manage-partition.pl $(date +"%Y-%m-%d" --date="32 week") VIP-SQLRW-DW.CI.PRD.LAX "" "weekly"
sudo -u mysql /usr/bin/perl /usr/local/bin/db-manage-partition.pl $(date +"%Y-%m-%d" --date="32 week") VIP-SQLRW-AUDIT.CI.PRD.LAX "" "weekly"
