```bash
for file in `ls`; do cat $file | shmux -e 0,2- -C10s -Bpc "sudo grep IPv6 duplicate address /var/log/messages" -; done
```
