#!/usr/bin/perl -w 

## by rcarreon Oct 2013

use DBI;
use strict;
use POSIX qw(strftime);
#The query to get all the tickets out of rt.gorillanation.com queue status change and write the output into a file
#
#
#DB variables , set up the ENV 
#
my $date = strftime "%m/%d/%y", localtime;
my $timestamp = localtime(time);
my $driver = "mysql";
my $database = "noc_statuschange";
my $dsn = "DBI:$driver:database=$database";
my $userid = "noc_sc";
my $passwd = "changeme";
my $db_conn = DBI->connect( $dsn, $userid, $passwd ) or die $DBI::errstr;
## RT Queries ## 
my $output="./t_output";
open OUT, "> $output" or die $!;
	my $Grand_query=`/app/shared/http/reports/cgi-bin/rt ls -o -Created -t ticket " Queue = 'Q_StatusChange' AND  (  Status = 'open' OR Status = 'new' OR Status = 'stalled' OR Status = 'resolved' OR Status = 'closed') AND Subject NOT LIKE 'Fwd:' AND Subject NOT LIKE 'Re:' AND Subject NOT LIKE 'reminder' AND Subject NOT LIKE 'review'" | cut -d : -f 1 | sort -n `;
	print  OUT $Grand_query;
close OUT;
my $tkts_found=`cat $output | wc -l `;
chomp($tkts_found);
print "$tkts_found\t"."tickets were found in Queue Status Change \n";
#The queries to our db
my $t_query = $db_conn->prepare("INSERT INTO tickets(tTicket_no, tFname, tLname, tCdate, tSdate, tOwner, tType, tTicket_status) VALUES ( ?,?,?,?,?,?,?,?)");
#reading the output file line by line 
my $line;
sub tickets_ops{
	open VER, "< $output" or die $!;
	while($line = readline(VER)){
        $line=~ m/(\d+)/;
	my $tickt = $1;
	##Validation to see if ticket is already in our tables
	my $sql= "select count(*) as tTicket_no from tickets where tTicket_no = $tickt";
	my $t_query1 = $db_conn->prepare($sql);
	my $sql_out =$t_query1->execute or die $DBI::errstr;
	my $result = ${$t_query1->fetch()}[0];
	my $tStatus=`/app/shared/http/reports/cgi-bin/rt show ticket/$tickt | grep -i ^status | cut -d : -f 2 `;
	
		if ($result < 1){
			if (!($tStatus=~ m/closed/ || $tStatus=~ m/resolved/)){
			 
				##RT queries	
				my $tOwner=`/app/shared/http/reports/cgi-bin/rt show ticket/$tickt/history -f created,content | grep -m 1 "Content" | awk '{print \$5\,\$6}'`;
				my $tFname=`/app/shared/http/reports/cgi-bin/rt show ticket/$tickt/history -f created,content | grep -m 1 "First" | cut -f2 -d ":"`;
				my $tLname=`/app/shared/http/reports/cgi-bin/rt show ticket/$tickt/history -f created,content | grep -m 1 "Last" | cut -f2 -d ":"`;
				my $Cdate=`/app/shared/http/reports/cgi-bin/rt show ticket/$tickt | grep -m 1 "Created" | awk ' {print \$3 \,\$4\,\$6}' `;
				my $t2Cdate=`date -d "$Cdate" +%y/%m/%d`;
				my $Sdate=`/app/shared/http/reports/cgi-bin/rt show ticket/$tickt/history -f content | grep -m 1 "Date" | cut -f2 -d":"`;
				my $tSdate=`date -d "$Sdate" +%y/%m/%d`;
				my $tType=`/app/shared/http/reports/cgi-bin/rt show ticket/$tickt/history -f created,content | grep -m 1 -i change | cut -d : -f 1 | awk '{print \$3}' `;
				if (!($tType=~ m/Separation/ || $tType=~ m/Move/)) {
					$tType=`/app/shared/http/reports/cgi-bin/rt show ticket/$tickt/history -f created,content | grep -m 1 -i change | cut -d : -f 2`;
				}
				#Getting rid of the trailing new line
				chomp($tickt,$tFname,$tLname,$t2Cdate,$tSdate,$tType,$tOwner,$tStatus);
				#executing the query so the actual insert can take place. 
	       			$t_query->execute($tickt,$tFname,$tLname,$t2Cdate,$tSdate,$tOwner,$tType,$tStatus) or die $DBI::errstr;
#				print "Ticket $tickt recorded into the TICKETS table \n";
				`echo "$date $timestamp \n ticket $tickt recorded in tickets table from RT" >> ./records.log`;
			}else{
				chomp($tStatus);
				 print "ticket $tickt is $tStatus"."no need to add to the table skiping\n";

			}
			
	       }
			##if ticket already within our tables check status, if resolved or closed get rid of them
			if ($result > 0){
        			print " ticket $tickt already in the TICKETS table checking status...\n ";
				if ($tStatus=~ m/closed/ || $tStatus=~ m/resolved/){
					my $del_q= "DELETE FROM tickets WHERE tTicket_no=$tickt";
					my $t_del = $db_conn->prepare($del_q);
					$t_del->execute() or die $DBI::errstr;
#					print "ticket $tickt change its status to $tStatus so it was deleted from tickets table";
					`echo "$date $timestamp \n ticket $tickt was $tStatus so it deleted from our records" >> ./deletes.log`;
				}
				
			}      
#				
	}
	close VER;
}
#executing tickets table operations 
&tickets_ops;
##Subrouting to add tickets from table tickets to matrix to ensure open or new status of the ticket
sub matrix_ops{
my $m_out = "./m_out";
open M_OUT, "> $m_out" or die $DBI::errstr;
       	my $m_query = $db_conn->prepare("select tTicket_no from tickets");
	$m_query->execute() or die $DBI::errstr;
	my $getting;
	while ( $getting = $m_query->fetchrow_array()){
		print M_OUT $getting."\n";
	}
close M_OUT;
open M_OUT, "< $m_out" or die $!;
	while($line = readline(M_OUT)){
        	$line=~ m/(\d+)/;
        	my $tickt = $1;
		my $sql1= "select count(*) as mTicket_no from matrix  where mTicket_no = $tickt";
		my $m_query1 = $db_conn->prepare($sql1);
		my $sql_out2 =$m_query1->execute or die $DBI::errstr;
		my $mresult = ${$m_query1->fetch()}[0];
		if ($mresult < 1){
				my $m_query2 = $db_conn->prepare("INSERT INTO matrix(mTicket_no) VALUES(?)");
				$m_query2->execute($tickt) or die $DBI::errstr;		
				#print "Ticket $tickt recorded into the MATRIX table \n";
				`echo "$date $timestamp \n ticket $tickt recorded in matrix table from tickets table" >> ./records.log`;
		}
		if ($mresult > 0){
        		print " ticket $tickt already in the MATRIX table skipping...\n ";
		}      
	}
	close M_OUT;
}
#executing matrix table operations 
&matrix_ops;
#Finishing and cleaning up 
print "Database updated,for details see log in /var/lib/statuschange\n";
$db_conn->disconnect();
`rm -f /app/shared/http/files/t_output`;
`rm -f /app/shared/http/files/m_out`;
