I create ansible hosts based on tp\_dns repo thusly.
```bash
rc0 (15:29:15)[fletcher.davis@fdavis-mac.gorillanation.local zones master]$  
tp_dns/zones$git grep --no-color 10.64 | grep gnmedia.net | grep -v netapp |  grep -v ':;' | grep -v vip- | awk -F: '{print $2}' | awk '{print $1,$4}' > ~/gitrepos/tp_sysadmins/ansible/hosts.raw
tp_sysadmins/ansible$cat hosts.raw | python make_hosts.py > hosts
```

TODO:
* make box ip extraction cleaner, should only look at gnmedia.net file
* make_hosts.py should be more robust, different spacing, would be better to process from fqdn. IN A ip into fqdn ssh_host=ip lines instead of relying on awk
