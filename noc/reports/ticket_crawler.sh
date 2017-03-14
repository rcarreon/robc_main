#! /bin/sh

clear
rm -f cgi-bin/ticket_craw

#Globals
php="http://dev.nocreports.gnmedia.net/mail_template.php"

#Grab names from RT template, still testint
ticket_number=`./cgi-bin/rt ls -o -Created -t ticket " Queue = 'Q_StatusChange' " | head -n1 | cut -d":" -f1`
template_id=`./cgi-bin/rt show ticket/$ticket_number/history -f content | grep -m 3 "id/" | cut -f3 -d"/" | tail -1`
template=`./cgi-bin/rt show ticket/$ticket_number/history -f content | sed -n "/${template_id}/,/${template_id}/p"`
fields=`echo "${template}" | grep "\[" | tail -n+2 | head -n-2 | sed -e 's/\(\[[^]]*\) /\1/;s/\(\[[^]]*\) /\1/' `


#Specify how far to look at in days
days="30"
date=`date -d "now-${days}days" +"%d/%m/%y"`

#Recall tickets
tickets=`./cgi-bin/rt ls -o -Created -t ticket " Queue = 'Q_StatusChange' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' ) AND Created >= '${date}'" | cut -d":" -f1`

#Go through tickets
echo "${tickets}" | while read -r line;
do
	#Grabs info from each ticket
	tick=`./cgi-bin/rt show ticket/$line/history -f content`
	first=`echo "${tick}" | grep -m1 "First Name:" | cut -d":" -f2 | sed 's/ //g'`
	last=`echo "${tick}" | grep -m1 "Last Name:" | cut -d":" -f2 | sed 's/ //g'`
	date=`echo "${tick}" | grep -m1 "Date:" | cut -d":" -f2 | sed 's/ //g'`
	echo "~ * * * * * * * * * * * ~"
	echo "Ticket: $line, Name:$first $last, Date:$date"
	sections=`./cgi-bin/rt show ticket/$line | grep CF-SC | egrep -v N/A | egrep -v Done | egrep -v StatusChangeMatrix`
	echo "${sections}" | sed 's/CF-SC_//g;s/://g' | while read -r lone;
	do
#		emails=`./cf.sh $lone` <-- Was using previous script to query just one section of the CF, but was too slow
		premails=`echo "${fields}" | grep $lone | sed -r 's/, /,/g;s/ /./g;s/,/@evolvemediallc.com, /g;s/\)/@evolvemediallc.com)/'`
		emails=`echo "${premails}" | sed 's/.*(\(.*\)).*/\1/'`
		echo "$php?first=$first&last=$last&date=$date&sec=$lone&emails=${emails}" | sed 's/ /%20/g' >> cgi-bin/ticket_craw
	done
	echo ""
done
