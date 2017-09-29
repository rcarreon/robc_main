#!/bin/bash

fiche -o /var/lib/nginx/ -u nginx -d inttools.gnmedia.net -p 9999 &
service nginx start
bash
