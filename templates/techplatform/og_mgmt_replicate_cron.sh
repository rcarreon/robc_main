#!/bin/bash

/bin/date >> $3
/usr/bin/rsync --exclude '.snapshot' -ahv $1/ $2 >> $3
/bin/date >> $3
echo >> $3
