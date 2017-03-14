#!/usr/bin/perl -w
use strict;

# Perl modules #
use DBI;
use DBD::mysql;

my $datadir = "/sql/data/mysql";
my ($year,$month,$day,$minyear,$minmonth,$minday,$current_min,$current_param);

# SOURCE #
my %conn = (
    dw => {
        src_dbhost => "vip-sqlrw-dw.ci.prd.lax.gnmedia.net",
        src_dbname => "warehouse",
        src_dbuser => "sql_archive_r",
        src_dbpass => "Dx1L3uOr",
        dest_dbhost => "localhost",
        dest_dbname => "warehouse",
        dest_dbuser => "local_archive_w",
        dest_dbpass => "1OrIlLH4",
    },
    audit => {
        src_dbhost => "vip-sqlrw-audit.ci.prd.lax.gnmedia.net",
        src_dbname => "audit",
        src_dbuser => "sql_archive_r",
        src_dbpass => "oB1in2uQ",
        dest_dbhost => "localhost",
        dest_dbname => "audit",
        dest_dbuser => "local_archive_w",
        dest_dbpass => "1OrIlLH4",
    },
);

# LOG #
my %log = (
    dbhost => "localhost",
    dbname => "archive",
    dbuser => "local_archive_w",
    dbpass => "1OrIlLH4",
);

# CORRECT ARGUMENTS #
if ($#ARGV < 0) {
    print "A date is necesary\n";
    exit 1;
}

# VALIDATE CORRECT DATE FORMAT/RANGE #
if (validdate($ARGV[0]) == 0) {
    exit 1;
}

# SOURCE DATA #
my %data = (
    page              => {
        db              => "warehouse",
 	table           => "history_pages",
        query           => "SELECT CONCAT(
                                IFNULL(id,0),',',
                                IFNULL(page_id,0),',',
                                IFNULL(website_id,0),',',
                                IFNULL(category,0),',',
                                IFNULL(demographic_sex,0),',',
                                IFNULL(demographic_age,0),',',
                                IFNULL(content_rating,0),',',
                                IFNULL(impressions,0),',',
                                UNIX_TIMESTAMP(IFNULL(created,0)),',',
                                IFNULL(visible,0),'\n' ) AS field
                        FROM history_pages",
        datefield       => "created",
        dateint         => "0",
        },
    social	      => {
        db              => "warehouse",
	table           => "history_socials",
        query           => "SELECT CONCAT(
                                IFNULL(id,0),',',
                                IFNULL(page_id,0),',',
                                IFNULL(likes_fb,0),',',
                                IFNULL(shares_fb,0),',',
                                IFNULL(comments_fb,0),',',
                                UNIX_TIMESTAMP(IFNULL(created,0)),'\n' ) AS field
                        FROM history_socials",
        datefield       => "created",
        dateint         => "0",
	},
    timer	      => {
        db              => "warehouse",
	table           => "history_timers",
        query        	=> "SELECT CONCAT(
                                IFNULL(id,0),',',
                                IFNULL(domain_bitfield,0),',',
                                IFNULL(type,0),',',
                                IFNULL(time,0),',',
                                IFNULL(data,'NULL'),',',
                                UNIX_TIMESTAMP(IFNULL(created,0)),'\n' ) AS field
                        FROM history_timers",
        datefield       => "created",
        dateint         => "0",
	},
    stats_widget     => {
        db              => "warehouse",
        table           => "stats_widget",
        query           => "SELECT CONCAT(
                                IFNULL(created,0),',',
                                IFNULL(page_id,0),',',
                                IFNULL(website_id,0),',',
                                IFNULL(domain_bit,0),',',
                                IFNULL(shown_website_id,0),',',
                                IFNULL(`type`,0),',',
                                IFNULL(`key`,0),',',
                                IFNULL(clicks,0),',',
                                IFNULL(impressions,0),',',
                                IFNULL(traffic,0),'\n' ) AS field
                        FROM stats_widget",
        datefield       => "created",
        dateint         => "1",
        },
    stats_landing_page => {
        db              => "warehouse",
        table           => "stats_landing_page",
        query           => "SELECT CONCAT(
                                IFNULL(created,0),',',
                                IFNULL(page_id,0),',',
                                IFNULL(website_id,0),',',
                                IFNULL(domain_bit,0),',',
                                IFNULL(category,0),',',
                                IFNULL(sex,0),',',
                                IFNULL(age,0),',',
                                IFNULL(content,0),',',
                                IFNULL(`type`,0),',',
                                IFNULL(`key`,0),',',
                                IFNULL(clicks,0),',',
                                IFNULL(impressions,0),'\n' ) AS field
                        FROM stats_landing_page",
        datefield       => "created",
        dateint         => "1",
        },      
    stats_accounts   => {
        db              => "warehouse",
        table           => "stats_accounts",
        query           => "SELECT CONCAT(
                                IFNULL(created,0),',',
                                IFNULL(domain_bit,0),',',
                                IFNULL(account_id,0),',',
                                IFNULL(website_id,0),',',
                                IFNULL(incoming,0),',',
                                IFNULL(outgoing,0),',',
                                IFNULL(credits,0),',',
                                IFNULL(initial_credits,0),',',
                                UNIX_TIMESTAMP(IFNULL(updated,0)),'\n' ) AS field
                        FROM stats_accounts",
        datefield       => "created",
        dateint         => "1",
        },
    stats_widgets_account => {
        db              => "warehouse",
        table           => "stats_widgets_account",
        query           => "SELECT CONCAT(
                                IFNULL(created,0),',',
                                IFNULL(widget_id,0),',',
                                IFNULL(website_id,0),',',
                                IFNULL(incoming,0),',',
                                IFNULL(display,0),',',
                                IFNULL(display_basic,0),',',
                                IFNULL(display_contextual,0),',',
                                IFNULL(display_similar,0),',',
                                IFNULL(display_tag,0),',',
                                IFNULL(incoming_basic,0),',',
                                IFNULL(incoming_contextual,0),',',
                                IFNULL(incoming_similar,0),',',
                                IFNULL(incoming_tag,0),',',
                                UNIX_TIMESTAMP(IFNULL(updated,0)),'\n' ) AS field
                        FROM stats_widgets_account",
        datefield       => "created",
        dateint         => "1",
        },
    logs	     => {
        db              => "audit",
        table           => "logs",
        query           => "SELECT CONCAT(
                                IFNULL(id,0),',',
                                IFNULL(domain_bitfield,0),',',
                                IFNULL(REPLACE(REPLACE(REPLACE(REPLACE(url,'\\\\','_'),' ','_'),',','_'),'''','_'),''''),',',
                                IFNULL(REPLACE(REPLACE(REPLACE(REPLACE(refer,'\\\\','_'),' ','_'),',','_'),'''','_'),''''),',',
                                IFNULL(REPLACE(REPLACE(REPLACE(ip, ' ',''),',','|'),'''',''''''),''''),',',
                                UNIX_TIMESTAMP(IFNULL(created,0)),'\n' ) AS field
                        FROM logs",
        datefield       => "created",
        dateint         => "0",
	},
);

sub open_db_conn() {
    my $db = shift;
    my $host = shift;
    my $user = shift;
    my $passw = shift;
    my $dsn = "dbi:mysql:$db:$host:3306";
    return DBI->connect($dsn, $user, $passw) or die "Unable to connect: $DBI::errstr\n";
}
sub close_db_conn() {
    my $result = shift;
    my $close = shift;

    $result->finish;
    $close->disconnect;
}

my ($db, $result, @log, $log_id, @row, $table_file, $total, $exist);
my $where_cond = "";

# Iterate $conn hash
foreach my $key ( keys %conn ) {
  # Iterate $data hash
  foreach my $key_data ( keys %data ) {
      $minyear = $year;
      $minmonth = $month;
      $minday = $day;
      $current_min = $current_param;
      if ( ($conn{$key}{src_dbname}) eq ($data{$key_data}{db})  ) {

          while ($current_min <= $current_param){

              # VALIDATE PREVIOUS RUN
              &validate_previois( $data{$key_data}{db}, $data{$key_data}{table} );

              # INITIAL LOG #
              # Stored Procedure Create table if not exists. Also Insert log.
              &init_log( $data{$key_data}{db}, $data{$key_data}{table} );

              $where_cond = "";
              if ( $data{$key_data}{dateint} == 0 ) {
		  $where_cond = " WHERE ".$data{$key_data}{datefield}." >= '".$minyear."-".$minmonth."-".$minday." 00:00:00' AND ".$data{$key_data}{datefield}." <= '".$minyear."-".$minmonth."-".$minday." 23:59:59'";
              } else {
                  $where_cond = " WHERE ".$data{$key_data}{datefield}." >= UNIX_TIMESTAMP('".$minyear."-".$minmonth."-".$minday." 00:00:00') AND ".$data{$key_data}{datefield}." <= UNIX_TIMESTAMP('".$minyear."-".$minmonth."-".$minday." 23:59:59')";
              }
	      print $where_cond;
   
              # GET DATA #
              # Connection to source
              &get_data( $conn{$key}{src_dbhost}, $conn{$key}{src_dbuser}, $conn{$key}{src_dbpass}, 
                         $data{$key_data}{db}, $data{$key_data}{table}, 
                         $data{$key_data}{query}.$where_cond );

              # WRITE INTO DESTINATION TABLE #
              # Selected rows are written into the destination file
              &write_data ( $data{$key_data}{db}, $data{$key_data}{table} );

              # REPAIR DESTINATION TABLE # 
              &repair_table( $conn{$key}{dest_dbhost}, $conn{$key}{dest_dbuser}, $conn{$key}{dest_dbpass}, $data{$key_data}{db}, $data{$key_data}{table} );

              # ENDING LOG #
              &end_log( $data{$key_data}{db}, $data{$key_data}{table} );

              &day_increment(1);
          }
      }
  }
}


sub validate_previois{
    my $key_data_db = shift;
    my $key_data_table = shift;

    $db = &open_db_conn($log{dbname}, $log{dbhost}, $log{dbuser}, $log{dbpass});
    $result = $db->prepare("CALL archive.archive_sp_validate_write ('".$key_data_db."','".$key_data_table."','".$key_data_table."_".$minyear.$minmonth."','".$ARGV[0]."')");
    if (defined($result)) {
        print "\nValidate previous execution ".$key_data_table."_".$minyear."".$minmonth,"\n";
        $result->execute() or do {
            &mail_log( "\n[ERROR]: PROCESS STOPPED WHILE VALIDATION FOR: ".$key_data_table."\n\n" );
            die "\n[ERROR]:Could not validate previous executions ".$key_data_table."\n\n";
        }
    } else {
        &mail_log( "\n[ERROR]: PROCESS STOPPED WHILE VALIDATION FOR: ".$key_data_table."\n\n");
        die "\n[ERROR]:Could not validate previous executions for ".$key_data_table."\n\n";
    }
    $exist = 0;
    while (@log = $result->fetchrow_array()){
        $exist = $log[0];
        $minyear = $log[1];
        $minmonth = $log[2];
        $minday = $log[3];
    }
    &close_db_conn( $result, $db );

    if ( $exist == 0 ) {
        &mail_log( "\n[ERROR]: PROCESS STOPPED DUE PREVIOUS EXECUTIONS FOR: ".$key_data_table."_".$minyear."".$minmonth."\n\n" );
        die "\n[ERROR]: Date was previously run for ".$key_data_table."_".$minyear."".$minmonth."\n\n";
    } else {
        # &day_increment(1);

        if ($current_param < $current_min){
            &mail_log( "\n[ERROR]: LATER DATES WERE PREVIOUSLY PROCESSED FOR: ".$key_data_table."_".$minyear."".$minmonth."\n\n" );
            die "\n[ERROR]: Later dates were previously processed for ".$key_data_table."_".$minyear."".$minmonth."\n\n";
        }
    }
}


sub init_log() {
    my $key_data_db = shift;
    my $key_data_table = shift;

    $db = &open_db_conn($log{dbname}, $log{dbhost}, $log{dbuser}, $log{dbpass});
    $result = $db->prepare("CALL archive.archive_sp_insert_log ('".$key_data_db."','".$key_data_table."','".$key_data_table."_".$minyear.$minmonth."','".$ARGV[0]."','".$year.$month."','".$minyear."-".$minmonth."-".$minday."')");

    if (defined($result)) {
        print "\nInit $key_data_table...";
        $result->execute() or do {
            &mail_log( "\n[ERROR]: Could not stored the initial log for $key_data_table\n\n" );
            die "\n[ERROR]:Could not execute the query for $key_data_table\n";
        };
        print "\nGetting data from $key_data_table";
    } else {
        die "\n[ERROR]:Could not stored the initial log for $key_data_table\n";
    }

    $log_id = 0;
    while (@log = $result->fetchrow_array()){
        $log_id = $log[0];
    }
    &close_db_conn( $result, $db );
}


sub end_log() {
    my $key_data_db = shift;
    my $key_data_table = shift;

    if (&update_log($log_id,62,"Successful finish $key_data_table",$total,$key_data_table)) {
        print "\nSuccessful finish $key_data_table.\n";
    } else {
        &mail_log( "\n[ERROR]: Could not save finishe log $key_data_table\n\n" );
        die "\n[ERROR]:Could not save finishe log $key_data_table\n";
    }
}


sub get_data() {
    my $key_src_host = shift;
    my $key_src_user = shift;
    my $key_src_pass = shift;
    my $key_data_db = shift;
    my $key_data_table = shift;
    my $key_data_query = shift;

    $db = &open_db_conn($key_data_db, $key_src_host, $key_src_user, $key_src_pass);
    # Select from source table
    $result = $db->prepare($key_data_query);

    if (defined($result)) {
        print "  (DONE)";
        $result->execute() or do {
            &update_log($log_id,7,"[ERROR] Executing select data",0,$key_data_table);
            &mail_log( "\n[ERROR] Selecting data $key_data_table\n\n" );
            die "\n[ERROR]:Could not execute the query for $key_data_table\n";
        };
        &update_log($log_id,6,"Selecting data",0,$key_data_table);
        print "\nWriting into ".$datadir."/".$key_data_db."/".$key_data_table."_".$minyear.$minmonth.".CSV";
    } else {
        &update_log($log_id,7,"[ERROR] Selecting data",0,$key_data_table);
        &mail_log( "[ERROR] Selecting data $key_data_table\n\n" );
        die "\n[ERROR]:Could not execute the query for $key_data_table\n";
    }
}


sub write_data() {
    my $key_data_db = shift;
    my $key_data_table = shift;
    my $str = '';
    
    $table_file = $datadir."/".$key_data_db."/".$key_data_table."_".$minyear.$minmonth.".CSV";
    open NEWFILE, ">>$table_file" or do {
        &update_log($log_id,7,"[ERROR] Opening file",0,$key_data_table);
        &mail_log( "\n[ERROR] Opening file $key_data_table\n\n" );
        die "\n[ERROR]:Can't open $table_file\n";
    };

    $total = 0;
    while (@row = $result->fetchrow_array()){
        if ($key_data_table eq 'logs') {
            $row[0] =~ s/[^\n\/-_:.,&%=a-zA-Z0-9]//g;
        }
        print NEWFILE $row[0];
        $total = $total+1;
    }
    print "  (DONE)";
    print "\n   Total rows: ".$total;

    close NEWFILE or do {
        &update_log($log_id,15,"[ERROR] Closing file",$total,$key_data_table);
        &mail_log( "\n[ERROR]:Can't close $table_file\n\n" );
        die "\n[ERROR]:Can't close $table_file\n";
    };

    &update_log($log_id,14,"File writen",$total,$key_data_table);
    &close_db_conn( $result, $db );
}


sub repair_table() {
    my $key_dest_host = shift;
    my $key_dest_user = shift;
    my $key_dest_pass = shift;
    my $key_data_db = shift;
    my $key_data_table = shift;

    print "\nRepairing table ".$key_data_db.".".$key_data_table."_".$minyear.$minmonth;
    $db = &open_db_conn($key_data_db, $key_dest_host, $key_dest_user, $key_dest_pass);
    $result = $db->prepare("REPAIR TABLE ".$key_data_table."_".$minyear.$minmonth);

    if (defined($result)) {
        print "  (DONE)";
        $result->execute() or do {
            &update_log($log_id,31,"[ERROR] Repairing table",0,$key_data_table);
            &mail_log( "\n[ERROR]: Could not repair table $key_data_table\n\n" );
            die "\n[ERROR]:Could not repair table $key_data_table\n";
        };
        &update_log($log_id,30,"Repairing table",$total,$key_data_table);
    } else {
        &update_log($log_id,31,"[ERROR] Repairing table",0,$key_data_table);
        &mail_log( "\n[ERROR]:Could not repair table $key_data_table\n\n");
        die "\n[ERROR]:Could not repair table $key_data_table\n";
    }
    &close_db_conn( $result, $db );
}


sub update_log() {
    my $logid = shift;
    my $status = shift;
    my $text = shift;
    my $rows = shift;
    my $table = shift;

    my $db = &open_db_conn($log{dbname}, $log{dbhost}, $log{dbuser}, $log{dbpass});
    my $result = $db->prepare("CALL archive.archive_sp_update_log(".$log_id.",".$status.",'".$text."',".$rows.")");

    if (defined($result)) {
        $result->execute() or do {
            &close_db_conn( $result, $db );
            return 0;
        };
        &close_db_conn( $result, $db );
        return 1;
    } else {
        &close_db_conn( $result, $db );
        return 0;
    }
}


&mail_log( "" );

sub mail_log() {
    my $prev_content = shift;
    my $subject = "[archive] DW-AUDIT for $ARGV[0]";
    my $logrcpt = "dba\@evolvemediallc.com";
    my ($mail_db, $mail_result, @content);

    $mail_db = &open_db_conn($log{dbname}, $log{dbhost}, $log{dbuser}, $log{dbpass});
    $mail_result = $mail_db->prepare("SELECT * FROM archive.log WHERE param = '".$ARGV[0]."' ORDER BY from_table, from_date");
    if (defined($mail_result)) {
        $mail_result->execute() or do {
        print "\n[ERROR]:Could not send email\n";
        };
    } else {
        print "\n[ERROR]:Could not send email\n";
    }
    open (MAIL, "|mailx -s \"$subject\" $logrcpt");

    print MAIL $prev_content;

    print MAIL "Data moved: \n";
    while (@content = $mail_result->fetchrow_array()){    
        print MAIL "\n\tTo: ".$content[1].".".$content[3]."\n\tRows: ".$content[7]."\n\tStatus: ".$content[6]."\n\tDate: ".$content[4]."\n";
    }
    print MAIL "\n\nScript.";
    close MAIL;

    &close_db_conn($mail_result, $mail_db);
    return 0;
}


### VALIDATE Date BETWEEN 2010-01-01 AND 2015-12-31 ###
sub validdate {
    if ($_[0] !~ /(\d{4})-(\d\d)-(\d\d)/) {
        print "Wrong date format: '$ARGV[0]'\n";
        print "Correct date format: 'yyyy-mm-dd'\n\n";
        return 0;
    }
    $year = substr $_[0],0,4;
    $minyear = $year;
    if ( ($year < 2010) || ($year > 2015) ) {
        print "Invalid year. Only years from 2010 to 2015 are allowed\n\n";
        return 0;
    }
    $month = substr $_[0],5,2;
    $minmonth = $month;
    if (($month < 1) || ($month > 12)) {
        print "Invalid month\n\n";
        return 0;
    }
    $day = substr $_[0],8,2;
    $minday = $day;
    if ( ($day < 1)  ||
         ($day > 31) ||
        (($day > 30) && (($month == 4) || ($month == 6) || ($month == 9) || ($month == 11))) ||
        (($day > 28) && ($month == 2) && ($year != 2012)) ||
        (($day > 29) && ($month == 2) && ($year == 2012)) ) {
        print "Invalid day\n\n";
        return 0;
    }
    $current_min = "$minyear$minmonth$minday";
    $current_param = "$year$month$day";
    return 1;
}

sub day_increment {
    my $increment  = shift;
    my @months = qw(Jan=31 Feb=28 Mar=31 Apr=30 May=31 Jun=30
                    Jul=31 Aug=31 Sep=30 Oct=31 Nov=30 Dec=31);  # Array of months and days
    my ($m, $mTotal) = split(/\=/, $months[$minmonth-1]);           # Extracting initial months total days

    $minday += $increment;         # Adding incremental value to start day
    while ($minday > $mTotal) {    # Start of incrementing while loop
        $minday -= $mTotal;        # Subtracts $mTotal from $day to increment month
        $minmonth++;               # Increments month

        if ($minmonth > ($#months+1)) {  # Checks if $month value is larger than 12
            $minmonth -= ($#months+1);   # Subtracts 12 from the value of $month
            $minyear++;                  # Increments year value
        }
        
        ($m, $mTotal) = split(/\=/, $months[$minmonth-1]);  # Extracts next months total days
    }

    $minday   = sprintf("%02s", $minday);      # Prepends value of $day with 0's if the total digits are < 2
    $minmonth = sprintf("%02s", $minmonth);    # Prepends value of $month with 0's if the total digits are < 2
    $minyear  = sprintf("%04s", $minyear);     # Prepends value of $year with 0's if the total digits are < 4

    $current_min = "$minyear$minmonth$minday";
}
