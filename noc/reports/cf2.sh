#! /bin/sh

ticket_number=`./cgi-bin/rt ls -o -Created -t ticket " Queue = 'Q_StatusChange' " | head -n1 | cut -d":" -f1`
template_id=`./cgi-bin/rt show ticket/$ticket_number/history -f content | grep -m 3 "id/" | cut -f3 -d"/" | tail -1`
template=`./cgi-bin/rt show ticket/$ticket_number/history -f content | sed -n "/${template_id}/,/${template_id}/p"`

fields=`echo "${template}" | grep "\[" | tail -n+2 | head -n-2 | sed -e 's/\(\[[^]]*\) /\1/;s/\(\[[^]]*\) /\1/' `
#emails=`echo "${fields}" | grep $1 | sed -r 's/, /,/g;s/ /./g;s/,/@evolvemediallc.com, /g;s/\)/@evolvemediallc.com)/'`

#echo $emails | sed 's/.*(\(.*\)).*/\1/'

echo $emails
