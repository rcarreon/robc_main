#! /bin/sh                                                                                                                                                                                     

echo ""

#Grab names from RT template, still testint
ticket_number=`./cgi-bin/rt ls -o -Created -t ticket " Queue = 'Q_StatusChange' " | head -n1 | cut -d":" -f1`
template_id=`./cgi-bin/rt show ticket/$ticket_number/history -f content | grep -m 3 "id/" | cut -f3 -d"/" | tail -1`
template=`./cgi-bin/rt show ticket/$ticket_number/history -f content | sed -n "/${template_id}/,/${template_id}/p"`
fields=`echo "${template}" | grep "\[" | tail -n+2 | head -n-2 | sed -e 's/\(\[[^]]*\) /\1/;s/\(\[[^]]*\) /\1/' `


#Specify how far to look at in days
days="60"
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
        sections=`./cgi-bin/rt show ticket/$line | grep CF-SC | egrep -v N/A | egrep -v Done | egrep -v StatusChangeMatrix`
        rdate=`date -d"now" +%s`
	rdateh=`date +%m/%d/%Y`
        sdate=`date -d"$date" +%s`
	sdateh=
        echo "Ticket: $line, Name:$first $last, Date:$date"
        if [ $((((rdate-sdate))/86400)) -gt 10 ]; then
        echo "Status - overdue"
	ms="" 
	appended_sections=""
	tmpsec=`echo "${sections}" | sed 's/CF-SC_//g;s/://g'`
	
	while IFS= read -r lone
        do
		ms+=`echo "${fields}" | grep $lone | sed 's/\[//g;s/\]//g'`
		appended_sections+=`echo "${fields}" | grep $lone | sed 's/\[//g;s/\]//g'`
		appended_sections+="\n"
		ms+="<br>"

        done <<< "$tmpsec"

        appended_sections=`echo -e "${appended_sections}"`
	echo "${appended_sections}"

               #sends email
                export from="NOC Leads <noc-leads@evolvemediallc.com>"
                export to="rodolfo.angel@evolvemediallc.com"
                export cc=""
                export subject="Status Change Review - [${first} ${last}] [${date}]"
                
                export message="
<b>Status change Review/Reminder</b><br><br>
<b>Name:</b> $first $last<br>
<b>Date of Review: </b> $rdateh<br>
<b>Date of Separation: </b> $date<br><br>
<b>The Sections without response:</b>
<br>$ms
"
                (       
                echo "From: ${from}";
                echo "To: ${to}";
                echo "Subject: ${subject}";
                echo "Cc: ${cc}";
                echo "Content-Type: text/html";
                echo "MIME-Version: 1.0";
                echo "";
                echo "${message}";
                ) | /usr/sbin/sendmail -t               



	echo ""
        else echo "Status - OK!... or check the date"
        echo ""
        fi
done
