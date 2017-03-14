#!/usr/bin/perl -w
use strict;

use DBI;
use MIME::Base64;
use MIME::Lite;
use Time::Piece;
use Time::Seconds;
use warnings;
# use LWP::UserAgent;
# use WWW::Curl::Simple;

my $dbuser = "dbops";
my $dbpasswd = decode_base64("ZXZvbHZlZ2VuaXVzOTg3");
my $dbnameOLTP = "tewn";
my $dbhostOLTP = "sql1v-56-ci.ci.prd.lax.gnmedia.net";
my $dbnameAudit = "audit";
my $dbhostAudit = "sql1v-56-audit.ci.prd.lax.gnmedia.net";

sub send_mail {
    my $filename = shift;
    my $subject = "[prunning-pages] - ".shift;
    my $text = shift;
    my $final_mail_content = shift;
    my $new_filename = "/tmp/".$filename."_".time.".csv";


    open (MYFILE, ">>".$new_filename);
    print MYFILE $final_mail_content;
    close (MYFILE); 
    
    my $mail = MIME::Lite->new(
        To      => "TechTeamCrowdIgnite\@evolvemediallc.com",
        Cc      => "dba\@evolvemediallc.com",
        Subject => $subject,
        Type    => 'multipart/mixed'
    ) or die "Error creating multipart container: $!\n";

    $mail->attach(
        Type     => 'TEXT',
        Data     => $text."\n\nPrunning Script."
    );

    $mail->attach(
        Type     => 'application/csv',
        Path     => $new_filename,
        Filename => $filename."_".time.".csv",
        Disposition => 'attachment'
    );
    $mail->send();

    return 1;
}

sub clean_tables {
    my ($db, $result);
    my $passw = $dbpasswd;

    $db = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
    $result = $db->prepare("TRUNCATE audit.redirected_pages");
    $result->execute();
    $result->finish;
    $db->disconnect;

    ($db, $result, $passw) = undef;

    $db = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
    $result = $db->prepare("TRUNCATE audit.fail_pages");
    $result->execute();
    $result->finish;
    $db->disconnect;

    ($db, $result, $passw) = undef;
}

sub prunning_url {
    my $query = "SELECT id, url FROM tewn.pages WHERE status = 0 ORDER BY id";
    my $db0 = DBI->connect("dbi:mysql:".$dbnameOLTP.":".$dbhostOLTP.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
    my $result0 = $db0->prepare($query);
    $result0->execute();
    $query = undef;
    
    while (my $tbl = $result0->fetchrow_arrayref) {
        my $url = '"'.$tbl->[1].'"';
        my $curl = qx(curl -sI $url | grep -iE '^(Location:[[:space:]]|HTTP/[[:digit:]](\.[[:digit:]])?)[ /.a-zA-Z0-9]+');
        my $retvalue = $?;
        
        $tbl->[1] =~ s/'/''/g;

        if ($retvalue == 0) {
            my @response = split /\n/, $curl;
            my @code = split / /, $response[0];

            if ($code[1] >= 300) {
                if ($code[1] < 400) {
                    my $in_system = 0;
                    my $new_url;

                    if (scalar(@response) > 1) {
                        $response[1] =~ s/Location: //g;
                        $new_url = $response[1];
                    }

                    $new_url =~ s/'/''/g;

                    $query = "SELECT id FROM tewn.pages WHERE url = '".$new_url."';";

                    my $db = DBI->connect("dbi:mysql:".$dbnameOLTP.":".$dbhostOLTP.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
                    my $result = $db->prepare($query);
                    if (my $rows = $result->execute) {
                        if ($rows!=0) {
                            $in_system = 1;
                        }
                    }
                    $result->finish;
                    $db->disconnect;
                    ($db, $result, $query) = undef;

                    $query = "INSERT INTO audit.redirected_pages(page_id, in_system, curl_code, response_code, current_url, new_url) VALUES (".$tbl->[0].", '".$in_system."', '".$retvalue."', ".$code[1].", '".$tbl->[1]."', '".$new_url."')";

                    $db = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
                    $result = $db->prepare($query);
                    $result->execute();
                    $result->finish;
                    $db->disconnect;
                    ($db, $result, $query, $url, $retvalue, $curl, $new_url) = undef;

                } else {

                    $query = "INSERT INTO audit.fail_pages(page_id, curl_code, response_code, url) VALUES (".$tbl->[0].", '".$retvalue."', ".$code[1].", '".$tbl->[1]."')";

                    my $db = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
                    my $result = $db->prepare($query);
                    $result->execute();
                    $result->finish;
                    $db->disconnect;
                    ($db, $result, $query, $url, $retvalue, $curl) = undef;
                }
            }
        } else {
                    $query = "INSERT INTO audit.fail_pages(page_id, curl_code, response_code, url) VALUES (".$tbl->[0].", '".$retvalue."', 0, '".$tbl->[1]."')";

                    my $db = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
                    my $result = $db->prepare($query);
                    $result->execute();
                    $result->finish;
                    $db->disconnect;
                    ($db, $result, $query) = undef;
        }
    }

    $result0->finish;
    $db0->disconnect;
}


sub get_redirected_report {
    my ($db, $result);
    my $query = "SELECT page_id, in_system, curl_code, response_code, current_url, new_url FROM audit.redirected_pages";
    my $mail_content = "page_id, in_system, curl_code, response_code, current_url, new_url\n";

    $db = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
    $result = $db->prepare($query);
    $result->execute();

    while (my $tbl = $result->fetchrow_arrayref) {
        $mail_content = $mail_content.$tbl->[0].", ".$tbl->[1].", ".$tbl->[2].", ".$tbl->[3].", ".$tbl->[4].", ".$tbl->[5]."\n";
    }

    $result->finish;
    $db->disconnect;

    ($db, $result, $query) = undef;

    &send_mail("redirected_pages","Redirected Pages","Redirected Pages (CSV format) are attached.",$mail_content);
}

sub get_error_report {
    my ($db, $result);
    my $query = "SELECT page_id, curl_code, response_code, url FROM audit.fail_pages";
    my $mail_content = "page_id, curl_code, response_code, url\n";

    $db = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
    $result = $db->prepare($query);
    $result->execute();

    while (my $tbl = $result->fetchrow_arrayref) {
        $mail_content = $mail_content.$tbl->[0].", ".$tbl->[1].", ".$tbl->[2].", ".$tbl->[3]."\n";
    }

    $result->finish;
    $db->disconnect;

    ($db, $result, $query) = undef;

    &send_mail("error_pages","Error Pages","Pages with error response code (CSV format) are attached.",$mail_content);
}


sub prunning_img {
    my ($db, $result, $dbAudit, $resultAudit, $dbOLTP, $resultOLTP);
    my $query = "SELECT id, image FROM tewn.pages WHERE status = 2 AND image <> ''";

    $db = DBI->connect("dbi:mysql:".$dbnameOLTP.":".$dbhostOLTP.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
    $result = $db->prepare($query);
    $result->execute();

    while (my $tbl = $result->fetchrow_arrayref) {
        $dbAudit = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
        $query = "REPLACE INTO audit.removed_page_images(page_id, image) VALUES (".$tbl->[0].", '".$tbl->[1]."')";
        $resultAudit = $dbAudit->prepare($query);
        $resultAudit->execute();
        $resultAudit->finish;
        $dbAudit->disconnect;

        $dbOLTP = DBI->connect("dbi:mysql:".$dbnameOLTP.":".$dbhostOLTP.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
        $query = "UPDATE tewn.pages SET image = '' WHERE id = ".$tbl->[0].";";
        $resultOLTP = $dbOLTP->prepare($query);
        $resultOLTP->execute();
        $resultOLTP->finish;
        $dbOLTP->disconnect;
    }
}

sub get_img_report {
    my ($db, $result);
    my $query = "SELECT page_id, image FROM audit.removed_page_images WHERE created >= date(now())";
    my $mail_content = "page_id, image\n";

    $db = DBI->connect("dbi:mysql:".$dbnameAudit.":".$dbhostAudit.":3306", $dbuser, $dbpasswd) or die "Unable to connect: $DBI::errstr\n";
    $result = $db->prepare($query);
    $result->execute();

    while (my $tbl = $result->fetchrow_arrayref) {
        $mail_content = $mail_content.$tbl->[0].", ".$tbl->[1]."\n";
    }

    $result->finish;
    $db->disconnect;

    ($db, $result, $query) = undef;

    &send_mail("removed_page_images","Removed image Pages","Removed image Pages (CSV format) are attached.",$mail_content);
}


&clean_tables();

&prunning_url();
&get_redirected_report();
&get_error_report();

&prunning_img();
&get_img_report();
