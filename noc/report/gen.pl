#!/usr/bin/perl -T

use strict;
use warnings;
use CGI;
use CGI::FormBuilder;
use Template;
use CGI::Carp qw(fatalsToBrowser); # only for testing
use DBI;

# connect to db
my $dbh = DBI->connect("DBI:mysql:noc", 'noc', 'noc');

  die "cannot connecto to db: " . DBI->errstr() unless $dbh;

my $q = new CGI;
my ($form, @fields, $new, @levopts);
my $break = "<br />";

print $q->header;

print $q->start_html(
  -title  => 'report',
  -author => 'jesus.camou@gorillanation.com',
  -style  => {
    'src' => '/css/style.css'
  },
);

  print $q->h1("rep");


  @fields = qw(name email subj site host level vipinfo vipref monit comm);
  @levopts = qw(CRITICAL DOWN RECOVERED);

  $form = CGI::FormBuilder->new(
    method   => 'post',
    fields   => \@fields,
    required => 'ALL',
    # won't use an actual temlate, just the css but wel'll prolly
    # need it to enable template toolkit?
    #  template => {
    #    type => 'TT2',
    #    #template => 'report.tmpl',
    #    variable => 'form'
    #},
    header   => 1,
    submit   => 1,
    # this appears to be broken :(
    validate => {
      email  => 'EMAIL'
    },
    
    messages => {
      form_required_text => 'Fill up all of the following fields:'
    }
  );
    
        $form->field(
          name    => 'vipinfo',
          type    => 'textarea',
          #columns => 50,
          cols    => '100',
          rows    => '20',
          label   => 'VIP Visualizer'
        );

        $form->field(
          name    => 'level',
          #fields => [qw/(levopts dos tres)/],
          type    => 'select',
          options => \@levopts,
        );
          
        $form->field(
          name    => 'subj', 
          label   => 'Subject'
        );
          
        $form->field(
          name    => 'vipref', 
          label   => 'VIP Link Ref',
          size    => 100 
        );

        $form->field(name => 'monit',
          type    => 'textarea',
          cols    => '100',
          rows    => '6',
          label   => 'Monit Alerts'
        );
          
        $form->field(name => 'comm', 
          label   => 'Comments',
          type    => 'textarea',
          cols    => '100',
          rows    => '6'
        );

#if ($form->submitted && $form->validate) {
#    # same, broken
#    # print $form->confirm(template => 'gone.tmpl');
#    print $form->confirm;
#}
#else {
#    print $form->render(header => 0);
#}

#print $form->render(header => 0);

    print "FIELDS:$break";

    foreach ($form->field) {
      print "$_.$break" 
    }

    foreach (@fields) {
      #$_ = $form->cgi_param($_);
    }

    #print "$vipref<br />";

print $q->end_html;

 if ($form->submitted && $form->validate) {
    # same, broken
    # print $form->confirm(template => 'gone.tmpl');
           print $form->confirm;
#print $form->confirm(template => 'report.tmpl');
    # print $form->confirm;

      my $qname = $form->cgi_param('name');
      my $qemail = $form->cgi_param('email');
      my $qsubj = $form->cgi_param('subj');
      my $qsite = $form->cgi_param('site');
      my $qhost = $form->cgi_param('host');
      my $qlevel = $form->cgi_param('level');
      my $qvipinfo = $form->cgi_param('vipinfo');
      my $qvipref = $form->cgi_param('vipref');
      my $qmonit = $form->cgi_param('monit');
      my $qcomm = $form->cgi_param('comm');

      my $sth = $dbh->prepare("INSERT into reports (name, email,
        subj, site, host, level, vipinfo, vipref, monit, comm)
        values('$qname', '$qemail', '$qsubj', '$qsite', '$qhost', '$qlevel',
        '$qvipinfo', '$qvipref', '$qmonit', '$qcomm')");

      $sth->execute() || die "db execution failed: " . $sth->errstr();
      
      # disconnect from db before leaving..
      $dbh->disconnect();
    }

    else {
      print $form->render(header => 0);
    }

#upload form, ignore for now
#print $q->start_html(-title => 'test page');
#print $q->start_multipart_form;
#print $q->filefield(
#        -name => 'filename',
#    );
#print $q->submit(-value => 'Upload File');
#    print $q->end_form;

exit; 
