### Author: Wojciech Jawor 
###
###

package RTFront::QuickTicket;

our $VERSION = '1.0';
our $ABSTRACT = '';

use warnings;
use strict;

use vars qw/$r $m %session/;

use RTFront::Config;

use XML::Simple;
use HTML::Template;
use CGI();
use URI::Escape;
use Data::Dumper;

# RT API
use lib "/opt/rt3/lib";
use RT;
use RT::Interface::CLI qw(CleanEnv);
use RT::CurrentUser;
use RT::Ticket;
use RTx::AssetTracker;
use RT::Authen::ExternalAuth;


$|++;

# GLOBALS
use constant QT_PATH => $RTFront::Config::QT_PATH;
use constant MAIN_TMPL => QT_PATH . '/submission.tmpl';
use constant SEARCH_TMPL => QT_PATH . '/search.tmpl';
use constant CONFIRM_TMPL => QT_PATH . '/confirm.tmpl';
use constant TMP_PATH => '/app/tmp/';
use constant RT_URL => $RTFront::Config::RT_URL;
use constant QT_URL => $RTFront::Config::QT_URL;

# Init RT
RT::Init();

# To communicate error
my $errormsg;



#-------------------------------------------------------------------------------------------------------------
# Routine:      handler
# Description:  This is the starting place for mod_perl.
#               This routine first reads all configuration files, then calls other routines to 
#               resolve  emplate variables and display the template. 
# Input:        http params 
#   
# Returns:      always 1 to satisfy mod_perl, prints page on stdout
#-------------------------------------------------------------------------------------------------------------
sub handler
{
    my $qry = new CGI;
    print "Content-Type: text/html\n\n";

    # If confirmation page then handle and exit
    if (defined $qry->param('confirmid')) {
        show_confirmation($qry->param('confirmid'));
        return 0;
    }

    $errormsg = '';

    # initialize page template 
    my $template = HTML::Template->new(filename => MAIN_TMPL);

    # Read request configuration
    my $tick_config;        # request configuration
    if ((defined $qry->param('mttype')) && ($qry->param('mttype') ne '')) {
        ($tick_config, $errormsg) = &generate_ticket_configuration($qry, $template);
    }
    goto SEND if ($errormsg);

    # Show search popup if needed
    if (defined $qry->param('subpage')) {
        show_search_page($qry, $tick_config); 
        return 0;               
    }

    # generate session id if none given
    my $sessionid = $qry->param('sessionid');
    $sessionid = &gen_sessionid() unless ($sessionid);


    #
    # Here comes the ugly code to generate the dropdowns as
    # well as the Javascript to drive them
    #
    
    my @dtypes = ( );           # array of request types to generate template
    my %cat_types = ( );
    my @subcategory_list = ( ); 
    my @main_java_loop = ( );
    my @forward_subtype_loop = ( );
    my @results = ( );

    # Get all possible values for category custom field
    my $CategoryCF = new RT::CustomField(RT::SystemUser);
    $CategoryCF->Load('TicketCategory');
    my $cfv = $CategoryCF->Values();
 
    while (my $c = $cfv->Next()) {
        # we want to add categories that have at least one ticket in prod
        my $assets = RTx::AssetTracker::Assets->new(RT::SystemUser);
        
        if (!defined $qry->param('debug') || $qry->param('debug') eq '') {
            $assets->FromSQL("TYPE='QuickTicket' AND (STATUS='InService' or STATUS='production') AND CF.{TicketCategory}='". $c->Name . "'");
            next if ($assets->Count == 0);
        }
        
        $cat_types{$c->Name} = 1;
    }

    # Populate department list 
    push @dtypes, { ID => 0, TITLE => '-- SELECT --', SELECTED => '' };

    foreach (sort { $a cmp $b } keys %cat_types) {
        my $selected = ($qry->param('mdtype') eq $_) ? 'selected' : '';
        push @dtypes, { ID => $_, TITLE => $_, SELECTED => $selected };
    }

    # Generate JavaScript to drive the dropdowns
   
    # Don't bother if department not seleceted
    if (defined($qry->param('mdtype')) && ($qry->param('mdtype') ne '0')) {
    # List assets belonging to the chosen category
        my $assets = RTx::AssetTracker::Assets->new(RT::SystemUser);
        $assets->FromSQL("TYPE='QuickTicket' AND (STATUS = 'InService' OR STATUS='production') AND STATUS!='retired' AND CF.{TicketCategory}='".$qry->param('mdtype') . "'");
        $assets->FromSQL("TYPE='QuickTicket' AND STATUS!='retired' AND CF.{TicketCategory}='".$qry->param('mdtype') . "'") if ((defined $qry->param('debug')) && ($qry->param('debug') ne ''));

        # Fetch category tree from asset tracker
        my $subCategories = { root => {} };
        my $deepest_level = 0;

        while (my $asset = $assets->Next) {
            my $updateLevel = $subCategories;
            my $level = 0;
            my $cn = 'root';
            my @subCategories = getCFvalue($asset->id, 'TicketSubCategory');

            while (my $nn = shift @subCategories) {

                if (!exists $updateLevel->{$cn}->{$nn}) {
                    $updateLevel->{$cn}->{$nn} = {};
                }
                $updateLevel = $updateLevel->{$cn};
                $cn = $nn;

                $level++;

                if (!@subCategories) {
                    my ( $order ) = getCFvalue($asset->id, 'TicketSubCategoryOrder');
                    if (!defined $order) { $order = 0; }
                    $updateLevel->{$nn}->{ $asset->Description.':'.$order } = { $asset->Id }; 
                }

            }

            $deepest_level = $level if ($deepest_level < $level);
        }

        # Now generate subcategory dropdowns up to the deespest level required
        # Not all of them will be in use for each choice.
        # populate subcategory list
        for (my $i = 0; $i < $deepest_level+1; $i++) {
        my $label = 'Select specific request category';
        if ($i > 0) {
            $label = 'Select specific request';
        }
        push @subcategory_list, {
                    LABEL => $label, 
                    VISIBILITY => 'none', 
                    ID => 'subtype_element'.$i, 
                    NEXTID => 'subtype_element'.($i+1) };
        }

        # we have to populate the first dropdown
        # because there is no event that can trigger it
        $subcategory_list[0]->{VISIBILITY} = 'block';

        my $index = 1;
        # is this the final request dropdown, or another subcategory?
        if (keys %{$subCategories->{root}}) {
        # subcategory
        # Just fill in with the first level nodes
        my @ttypes;
            push @ttypes, { ID =>'', TITLE => '-- SELECT --', SELECTED => '' }; 

        foreach (sort keys %{$subCategories->{root}}) {
            my $selected = ($qry->param('subtype_element0') == $index) ? 'selected' : '';
            push @ttypes, { ID => $index++, TITLE => $_, SELECTED => $selected };
        }
            $subcategory_list[0]->{SUBTYPE_LOOP} = \@ttypes;    
        } else {
        # dropdown
            # populate request dropdown
            # build ticket list:
            my @asset_list;
        my @ttypes;
            while (my $asset = $assets->Next) {
                    push @asset_list, $asset;
            }

            # Populate request list
            push @ttypes, { ID => '', TITLE => '-- SELECT --', SELECTED => '' };
            foreach (sort { $a->Description cmp $b->Description } @asset_list) {
                    my $selected = ($qry->param('mttype') == $_->id) ? 'selected' : '';
                    push @ttypes, { ID => $_->id, TITLE => $_->Description, SELECTED => $selected };
            }

        # update dropdown information
        $subcategory_list[0]->{SUBTYPE_LOOP} = \@ttypes;
            $subcategory_list[0]->{NEXTID} = '';
        }

        # and now the Javascript that drives all this
        # @main_java_loop
    my @stack;
    
    foreach (sort keys %{$subCategories->{root}}) {
        push @stack, {  JAVAID => "subtype_element0", 
                    NODENAME => $_, 
                CHILDREN => $subCategories->{root}->{$_}  }; 
    }

    while (my $element = shift @stack) {
        # build element for index choices
        my @index_choices = ( );
        my $current_javaid = $element->{JAVAID};
        $current_javaid =~ m /(.*)(\d+)$/;
        my $next_javaid = "$1" . ($2 + 1);
        my $choice_index = 1;
        my $choice_value = 1;
        my @ttypes = ( );
        my $current_subtree = 0;

        while (1) {
            my @options = ( );
            # what are the children of this node?
            my $children = $element->{CHILDREN};
 
            my $index = 0;
            my $ttype = 0;

                        push @options, { OPTIONINDEX => $index,
                                         OPTIONNAME => '-- SELECT --',
                                         OPTIONVALUE => $index };

            $index++;
            if ($current_subtree < 2) {
                @ttypes = ( );
                            push @ttypes, {  ID => 0,
                                             TITLE => '-- SELECT --',
                                             SELECTED => '' };
            }       

            my @loop_elements = sort { &mysort($a, $b) } keys %{$element->{CHILDREN}};

            foreach (@loop_elements) {
            
                # if not a leaf
                    if (defined $element->{CHILDREN}->{$_}) {
                    # insert them as options

                                        my ($optname) = m/(.*):\d+$/;
                                        $optname = $_ if (!defined $optname);

                    push @options, { OPTIONINDEX => $index,
                             OPTIONNAME => $optname,
                             OPTIONVALUE => $choice_value };
                    $index++;

                    # push them on the stack
                    push @stack, {  JAVAID => $next_javaid,
                            NODENAME => $_,
                            CHILDREN => $element->{CHILDREN}->{$_}  };

                    my $selected = '';

                    if ($choice_value == $qry->param($next_javaid)) {
                        $current_subtree = 1;
                        $selected = 'selected';
                    }

                    if ($current_subtree < 2) {
                                            my ($optname) = m/(.*):\d+$/;
                                            $optname = $_ if (!defined $optname);

                            push @ttypes, { ID => $choice_value,
                                                        TITLE => $optname,
                                                        SELECTED => $selected };
                    }

                    $choice_value++;
        
                } else
                {
                    @options = ( );
                    $ttype = $_;
                }
            }

            if ($current_subtree == 1) { $current_subtree = 2; }
            
            my $snippet = '';
            if ($ttype != 0) {
                $snippet = 'document.ticket_form.submit(); return 1;';
            }

            # push options with index onto the @index_choices
            push @index_choices, {  INDEXVALUE => $choice_index++ , 
                        OPTIONS => \@options,
                        SNIPPET => $snippet,
                        TTYPE => $ttype };

            last if (!@stack); 
            last if ($stack[0]->{JAVAID} ne $current_javaid);           

            # if not last, get next element from stack
            $element = shift @stack;
        }
        
        # create o list of subtypes that follow:
        my @following = ( );
                $current_javaid =~ m /(.*)(\d+)$/;
        for (my $i = $2+1; $i < $deepest_level+1; $i++) {
                    push @following, { NAME => 'subtype_element'.$i };
            } 

        if (defined $qry->param($next_javaid)) {
                    $subcategory_list[$2+1]->{SUBTYPE_LOOP} = \@ttypes;
                    $subcategory_list[$2+1]->{VISIBILITY} = 'block';        
        }

        # insert this element
        push @main_java_loop, { SUBTYPE => $current_javaid, 
                    INDEXCHOICES => \@index_choices,
                    FOLLOWING => \@following }; 
        
        if (defined $qry->param($current_javaid)) {
            push @forward_subtype_loop, { SUBTYPE => $current_javaid,
                              SUBTYPEVALUE => $qry->param($current_javaid) }
        }
    }
    }

    # delete checked attachments, store the remaining in an array
    # find the next id ($max_id) to be used for an attachment
    my @file_list;
    my $max_id = 0;
    foreach ($qry->param('fileids'))
    {
        push(@file_list, { fileid => $_, filename => $qry->param($_) }) unless $qry->param("ch$_") eq 'on';
        if ($qry->param("ch$_") eq 'on') {
            &remove_attachment($_, $qry, $sessionid);
            push @results, { MESSAGE => "File " . $qry->param($_) . " has been removed "};
        }
        $max_id = ($_ + 1) if ($max_id <= $_);
    }

    # perform action:
    if (($qry->param('mcreate') eq "Submit") || ($qry->param('mattach') ne ""))
    {
        if ($qry->param('mattach') ne '') {
            # add an entry to the file list
            my $filename = $qry->param('mattach');
            push (@file_list, { fileid => $max_id, filename => $filename } );
            push @results, { MESSAGE => "File $filename has been uploaded. (Ticket hasn't been created yet.)" };

            # store the file in temporary directory
            &do_store_attachment( $max_id, $qry, $sessionid );
        }
    }

    if ($qry->param('mcreate') eq "Submit") {
        &do_submit($qry, $template, $tick_config);
    } elsif ($qry->param('maction') eq 'tick_templ')  {
        &do_template($qry, $template, $tick_config); 
    } 

SEND:

    # send the information to the templatete
    $template->param(RESULTS => \@results);
    $template->param(sessionid => $sessionid);
    $template->param(MAIN_JAVA_LOOP => \@main_java_loop);
    $template->param(FORWARD_SUBTYPE_LOOP => \@forward_subtype_loop);
    $template->param(SUBCATEGORY_LOOP => \@subcategory_list);
    $template->param(DEPARTMENT_LOOP => \@dtypes);
    $template->param(FILE_LOOP => \@file_list);
    $template->param(debug => $qry->param('debug'));
    $template->param(mttype => $qry->param('mttype'));
    $template->param(mdtype => $qry->param('mdtype'));
    $template->param(errormessage => $errormsg . $@) if ($errormsg || $@);

    print $template->output;
    return 0;
}

sub mysort {
    my $a = shift;
    my $b = shift;

    my ($na) = ($a =~ m/:(\d+)$/);
    my ($nb) = ($b =~ m/:(\d+)$/); 

    $na = 0 if (!defined $na);
    $nb = 0 if (!defined $nb);

    $na <=> $nb;
}

sub generate_ticket_configuration {
    my $qry = shift;
    my $template = shift;
    my $tick_config = undef;
    my @fields = ( );

    # Fields can be obtained from the template defined in the asset...
    if (getCFvalue($qry->param('mttype'), 'TicketTemplateFile'))
    {
        eval { $tick_config = XMLin(getLargeCFvalue($qry->param('mttype'), 'TicketTemplateFile'), 
                                forcearray => [ 'FIELD' ]); };
        return (undef, $@) if ($@);
    }

    my ($sub_type) = getCFvalue($qry->param('mttype'), 'TicketSubmissionType');

    if ($sub_type ne 'Stop') {
        push @fields, { RT => 'subject',
                        NAME => 'Subject',
                        HTMLTYPE => 'text/30',
                        DESCRIPTION => 'Request subject.' };
    }

    my $id = 1;
    @fields = (@fields, map +{ ( %$_, RT => "CUSTOM" . $id++ ) }, @{$tick_config->{FIELD}});

    # ...or from the queue custom fields...
    my ($show_queue_cf) = getCFvalue($qry->param('mttype'), 'TicketShowQueueCF');
    do_populate_custom_fields(\@fields, $qry, $show_queue_cf);  

    # ...or defined manuallly
    if ($sub_type eq 'LoginOnPage')
    {
        push @fields, { RT => '',
                        NAME => 'cclabel',
                        HTMLTYPE => 'label',
                        DESCRIPTION => &cc_message() };

        push @fields, { RT => 'ccwatchers',
                        NAME => 'CC',
                        HTMLTYPE => 'text',
                        REQUIRED => 'no', 
                        DESCRIPTION => 'List comma seperated email addresses. If an address is in domain gorillanation.com you may skip "@gorillanation.com". ' };

        push @fields, { RT => '',
                        NAME => 'loginlabel',
                        HTMLTYPE => 'label',
                        DESCRIPTION => &login_message() };

        push @fields, { RT => 'login',
                        NAME => 'Login',
                        HTMLTYPE => 'text',
                        DESCRIPTION => 'Enter your system login (first.lastname).' };

        push @fields, { RT => 'password',
                        NAME => 'Password',
                        HTMLTYPE => 'password',
                        DESCRIPTION => 'Enter your system password.' };
    }

    if ($sub_type eq 'Stop') {
        $template->param(STOP => 1);
    }
    
    $tick_config = { FIELD => \@fields };
    return ($tick_config, undef);
}

sub show_confirmation {
    my $id = shift;
    
    # initialize page template 
    my $template = HTML::Template->new(filename => CONFIRM_TMPL);

    # are we being redirected from the creation page?
    my $ref = RT_URL . '/Ticket/Display.html?id=' . $id;
    my $message = 'Ticket #' . $id . ' has been created.<BR>' .
                  'To view its status, <a href=https://' . $ref . '>click here</a>.<BR><BR>'.
                  'Thank you for submitting your request.<br>' .
                  'You will recieve an e-mail confirmation shortly.<br><br>' . 
                  'To submit another request <a href="/">click here.</a>';

    $template->param(message => $message);
    print $template->output;
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      do_store_attachment
# Description:  Stores attachment (specified by $qry->param('mattach') ) in a tmp directory.
#   
# Input:        $id - attachment id
#       $qry - CGI query variable
#       $sessionid - current session id
#   
# Returns:      
#-------------------------------------------------------------------------------------------------------------
sub do_store_attachment
{
    my ($id, $qry, $sessionid) = @_;
    
    # check if directory exists and if not create it
    my $directory = TMP_PATH . $sessionid . "/";
    umask(000); # UNIX file permission junk
    mkdir($directory, 0777) unless (-d $directory);
    
    # save file
    my $filename = $qry->param('mattach');
    my $file_handle = $qry->upload('mattach');
    open UPLOADFILE, ">$directory" . $id . "_" . $filename;      
    binmode UPLOADFILE;
    while (<$file_handle>)       
    {   
        print UPLOADFILE;  
    }          
       
    close UPLOADFILE;
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      cleanup_attachments
# Description:  Removes attachments along with their directory for a given session.
#   
# Input:        $sessionid - current session id
#   
# Returns:      
#-------------------------------------------------------------------------------------------------------------
sub cleanup_attachments
{
    my ($sessionid) = @_;
    
    # remove files inside directory
    my $directory = TMP_PATH . $sessionid . "/";
    unlink glob($directory . "*");

    # and the directory itself
    rmdir $directory;
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      remove_attachment
# Description:  Removes attachment by its id
#   
# Input:        $id - attachment id
#               $qry - CGI query variable
#               $sessionid - current session id
#   
# Returns:      
#-------------------------------------------------------------------------------------------------------------
sub remove_attachment
{
    my ($id, $qry, $sessionid) = @_;

    # remove files inside directory
    my $directory = TMP_PATH . $sessionid . "/";
    unlink $directory . $id . "_" . $qry->param($id);
}

#
#
#
#
#

sub show_search_page {
    my ($qry, $tick_config) = @_;
    my $field = $tick_config->{FIELD}->[$qry->param('subfieldname')];
    my $field_name = $qry->param('subfieldname');
    my $template = HTML::Template->new(filename => SEARCH_TMPL);

    if ($field->{HTMLTYPE} =~ m/^\s*search\/([\w\s]+)\/{0,1}(\d*)\/{0,1}(\d*)/i)
    {
        my $input = $qry->param('input');
        my $AssetOp = $qry->param("$field_name.AssetOp");
        my $AssetString = $qry->param("$field_name.AssetString");
        my $AssetField = $qry->param("$field_name.AssetField");

        # execute search if applies
        my $assets = RTx::AssetTracker::Assets->new(RT::SystemUser);

        if (defined $AssetString) {
             $assets->FromSQL("status != 'retired' AND TYPE='$1' and $AssetField $AssetOp '$AssetString'"); 
        }

        my @asset_list;
        while (my $asset = $assets->Next) {
             my $url = 'https://' . RT_URL . '/AssetTracker/Asset/Display.html?id=' . $asset->id;
             push @asset_list, { INPUT => $input, URL => $url, ASSET_NAME => $asset->Name };
        }

        my @customfield_list;
        foreach my $cf (split /\|/, $field->{CUSTOMFIELDS}) {
            push @customfield_list, { CFNAME => $cf };
        }

        $template->param(COUNT => $assets->Count);
        $template->param(FIELD_NAME => $field_name);
        $template->param(INPUT => $input);
        $template->param(ASSET_STRING => $AssetString);
        $template->param(MTTYPE => $qry->param('mttype'));
        $template->param(MDTYPE => $qry->param('mdtype'));
        $template->param(CUSTOMFIELDS => \@customfield_list);
        $template->param(ASSETS => \@asset_list);
        $template->param(SUBPAGE => $qry->param('subpage'));
        $template->param(SUBFIELDNAME => $qry->param('subfieldname'));
    }

    print $template->output;
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      do_submit
# Description:  Validates the input and submits a ticket or passes error messages to 
#       the template to be displayed later.  
#   
# Input:        $qry - CGI query variable
#       $template - page tempalte
#       $tick_config - ticket XML template
#   
# Returns:      
#-------------------------------------------------------------------------------------------------------------
sub do_submit
{

    my ($qry, $template, $tick_config) = @_;
    my %missing_fields = ( );

    # cycle through the fields and check if required fields are filled in
    foreach (@{$tick_config->{FIELD}})
    {
    if ((ref($_->{REQUIRED}) ne "HASH") && 
            ($_->{REQUIRED} !~ m/n/i) && 
            ($_->{HTMLTYPE} !~ m/label/i) && 
        ($qry->param($_->{RT}) eq ""))
    {
        if ($_->{HTMLTYPE} =~ m/^\s*attachment/i) {
        my @files = glob(TMP_PATH . $qry->param('sessionid') . '/*');
        next if (@files);
        }

        # error, report required field not defined
        $errormsg .= "Missing required field \"" . $_->{NAME} . "\"<BR>";
        $missing_fields{$_->{NAME}}=1;
    }
    }
    goto Error if ($errormsg ne '');

    # Figure out queue name 
    my $queue = RT::Queue->new(RT::SystemUser);
    $queue->Load(&getCFvalue($qry->param('mttype'), 'TicketDestinationQueue'));
    $errormsg = "Cannot locate queue " . join '', &getCFvalue($qry->param('mttype'), 'TicketDestinationQueue') 
    if ($queue->id eq '');
    goto Error if ($errormsg ne '');

        my $tid = &create_ticket_api($qry, $tick_config, $queue);

    if ((defined $tid) && ($tid != 0)) {
        # ticket created redirect to confirm page
            print '<meta HTTP-EQUIV="REFRESH" content="0;URL=';
        my $urlargs ='';
        if (defined $qry->param('debug') && ($qry->param('debug') ne '')) {
            $urlargs .= 'debug=1&';
        }
        $urlargs .= "confirmid=$tid";
        print 'https://' . QT_URL . '/?' . $urlargs . '">';
            exit(0);
        }

Error:
    # redisplay the template
    &do_template($qry, $template, $tick_config, \%missing_fields);
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      do_populate_custom_fields
# Description:  Reads queue custom fields and creates a data structure that can be understood by
#       do_template routine.  
#   
# Input:        $field_ref - reference to the data structure
#               $qry - input query
#   
# Returns:      
#-------------------------------------------------------------------------------------------------------------
sub do_populate_custom_fields {    
    my ($field_ref, $qry, $show_fields) = @_;    
    my ($name, $values, $rtcode, $htmltype, $description);    

    my $queue = RT::Queue->new(RT::SystemUser);    
    $queue->Load(join '', &getCFvalue($qry->param('mttype'), 'TicketDestinationQueue'));    

    my $cfs =  $queue->TicketCustomFields;    
    while ($_ = $cfs->Next()) {
        $name = $_->Name;
        $rtcode = "Object-RT::Ticket--CustomField-" . $_->id . "-Values";
        $htmltype = 'textarea/60/5';
        $values = '';
        $description = $_->Description;
        if ($_->Type eq 'Select') {
             $htmltype = 'dropdown';
             my $cfv = $_->Values();
             my $c;
             while ($c = $cfv->Next()) {
                $values .= '|' . $c->Name;
             }
        }
    if ($show_fields =~ m/yes/i)
        {   push @{$field_ref}, { RT => $rtcode,
                              NAME => $name,
                              HTMLTYPE => $htmltype,
                  REQUIRED => 'no',
                              VALUE => $values,
                              DESCRIPTION => $description };
    }
    }
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      create_ticket_api
# Description:  Validates login and creates ticket via API
#   
# Input:        $qry - input query
#               $tick_config - field configuration
#               $queue - destination queue AT object
#   
# Returns:      
#-------------------------------------------------------------------------------------------------------------
sub create_ticket_api {
    my ($qry, $tick_config, $queue) = @_;
    my %queue_cf = ( );
    my %ticket_cf_values = ( );
    my $ticket_values = '';
    my $login = $qry->param('login');
    my $cc = $qry->param('ccwatchers');
    my @watchers = split /\s*,\s*/, $cc;

    my $asset = RTx::AssetTracker::Asset->new(RT::SystemUser);
    $asset->Load($qry->param('mttype'));
    my @subcategory = getCFvalue($asset->id, 'TicketSubCategory');
    my $tsubject = join(' - ', @subcategory);
    $tsubject .= ' - ' if (@subcategory);
    $tsubject .= $asset->Description;

    # try to validate watchers list
    for (my $i = 0; $i < @watchers; $i++) {
    if ($watchers[$i] !~ /@/) {
        $watchers[$i] = $watchers[$i] . '@gorillanation.com';
    }

    if ($watchers[$i] !~ /\b[A-Z0-9._%-]+@[A-Z0-9.-]+\.[A-Z]{2,4}\b/i) {
        $errormsg = "Watchers list does not seem to be formatted properly at $watchers[$i]";
        return undef;
    }

    }

    if ($login =~ /^\d+$/) {
        $login = "rt$login";
    }

    # Get the prioritised list of external authentication services
    my @auth_services = @$RT::ExternalAuthPriority;

    my $val;
    ($val,$errormsg) = RT::Authen::ExternalAuth::DoAuth(\%session,$qry->param('login'),$qry->param('password'));
    $RT::Logger->debug("Autohandler called ExternalAuth. Response: ($val, $errormsg)");
    return undef if ($val == 0);  

    my $cfs =  $queue->CustomFields;
    while ($_ = $cfs->Next()) {
        $queue_cf{$_->Name} = "CustomField-" . $_->id;
    }

    foreach (@{$tick_config->{FIELD}}) {
        if (exists $queue_cf{$_->{NAME}}) {
            $ticket_cf_values{$queue_cf{$_->{NAME}}} = $qry->param($_->{RT});
        } else {
            next if ($_->{RT} eq 'ccwatchers');
        next if ($_->{RT} eq 'login');
            next if ($_->{RT} eq 'password');
        next if ($_->{RT} eq 'subject');
        next if ($_->{HTMLTYPE} eq 'label');
        my $fieldvalue = join ", ", $qry->param($_->{RT});
        if ($_->{HTMLTYPE} =~ m/^\s*attachment/i) {
        foreach my $fname (glob(TMP_PATH . $qry->param('sessionid') . '/*')) {
            $fname =~ m/\/(\d+)_(.*)$/;
            $fieldvalue .= $2 . ", ";
            }
        chop $fieldvalue;
        chop $fieldvalue;
        }
            $fieldvalue =~ s/&/&amp;/g;
        $fieldvalue =~ s/</&lt;/g;
            $fieldvalue =~ s/>/&gt;/g;
        $fieldvalue =~ s/\n/<br>/g;
            $ticket_values .= "<b>" . $_->{NAME} . "</b>: " . $fieldvalue . "<br><br>";
        }
    }

    # Create ticket
    my $ticket_text = "Ticket created by " . $session{'CurrentUser'}->UserObj->RealName;
    $ticket_text .= " (". $qry->param('login') . ").<br><br><br>" . $ticket_values;
    my $ticket = new RT::Ticket($session{'CurrentUser'});
    my $ticket_body = MIME::Entity->build(Type => "text/html",
                                          Data => $ticket_text);

    foreach (glob(TMP_PATH . $qry->param('sessionid') . '/*')) {
    my $filename = $_;
        $filename =~ s/.*[\/\\]\d+_//;
        my $filetype = `file -b -i "$_"`;
        chomp $filetype;
        $ticket_body->attach(Path => $_, Filename => $filename, Disposition => 'attachment', Type => $filetype);
    }

    my %ticket_vals = (Queue => $queue->Name,
                       Subject => $tsubject . ': ' . $qry->param('subject') . ' [qt:' . $asset->id . ']',
                       Requestor => $session{'CurrentUser'}->UserObj->EmailAddress,
               Cc => \@watchers,
                       MIMEObj => $ticket_body,
               %ticket_cf_values);

    my ($tid, $transaction_object, $error_rep) = $ticket->Create(%ticket_vals);

    if ((defined $tid) && ($tid != 0))
    {
        # Ticket created, set SLA attributes
        my $nt = RT::Ticket->new(RT::SystemUser);
        $nt->Load($tid);   
        my ($aid, $amsg) = $nt->SetAttribute(
            Name => 'SLAAcknowledged',
            Description => 'Attribute of an SLAdTicket',
            Content => getCFvalue($asset->id, 'TicketSLA-ACK')
        );

        ($aid, $amsg) = $nt->SetAttribute(
            Name => 'SLAResolved',
            Description => 'Attribute of an SLAdTicket',
            Content => getCFvalue($asset->id, 'TicketSLA-Resolve')
        );

        ($aid, $amsg) = $nt->SetAttribute(
            Name => 'BusinessHours',
            Description => 'Attribute of an SLAdTicket',
            Content => getCFvalue($asset->id, 'TicketBusinessHours')
        );

        return $tid;
    } else
    {
        $errormsg = "Could not create ticket. " . $error_rep;
    }
    return undef;
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      do_template
# Description: Populates the lower part of the window by setting approperiate variables in the HTML template  
#   
# Input:        $qry - CGI query variable
#               $template - page tempalte
#               $tick_config - ticket XML template
#               $correction - do we want to initialize the fields from the tempalte or put in user values
#   
# Returns:      
#-------------------------------------------------------------------------------------------------------------
sub do_template
{
    my ($qry, $template, $tick_config, $correction) = @_;
    my @ttemplate = ( );
    my @ltemplate = ( );
    my $color = '#eeeeee';
    my $findex = 0;

    my $asset = RTx::AssetTracker::Asset->new(RT::SystemUser);
    $asset->Load($qry->param('mttype'));
    my @subcategory = getCFvalue($asset->id, 'TicketSubCategory');
    
    foreach (@{$tick_config->{FIELD}})
    {
    # if value is empty XMLin will convert it into a HASH
    my $value = ( ref($_->{VALUE}) eq "HASH" ) ? '' : $_->{VALUE};
        my @values = ( ref($_->{VALUE}) eq "HASH" ) ? ( ) : split /\|/, $_->{VALUE};

    # if making a correction then we need to rollback to the values specified by the user
    $value = $qry->param($_->{RT}) if (defined $qry->param($_->{RT}));

    # define fields
        my $row_desc = undef;
        my $row_name = undef;
        my $row_required = 0;
        my $row_span = undef;
        my $row_cont = undef;
        my $field_name = undef;

        $field_name = "$_->{RT}";
        $row_name = "$_->{NAME}: " unless ( ref($_->{NAME}) eq "HASH");
        $row_desc = "$_->{DESCRIPTION} " 
        unless ( ref($_->{DESCRIPTION}) eq "HASH" || !defined($_->{DESCRIPTION}));
    $row_required = 1 unless ( ref($_->{REQUIRED}) eq "HASH" || $_->{REQUIRED} =~ m/n/i);

    if ($correction) {
        $row_name = "<font color='#aa0000'>&rarr; $row_name</font>" 
            if (exists $correction->{$_->{NAME}});
    }

    if ($_->{HTMLTYPE} =~ m/^\s*search\/([\w\s]+)\/{0,1}(\d*)\/{0,1}(\d*)/i)
    {
        my $targeturl = '/?subpage=search&subfieldname=' . $findex;
        $targeturl .= '&mdtype=' . $qry->param('mdtype') . '&mttype=' . $qry->param('mttype');
        $targeturl .= '&input=' . $_->{RT}; 
            $row_cont = "<textarea wrap='virtual' id='$field_name' name='$field_name' cols=$2 rows=$3>$value</textarea><BR>";
        $row_cont .= "<a href=\"javascript:openWindow('$targeturl');\">Search</a>";
    }
    ######### TEXTAREA
    elsif ($_->{HTMLTYPE} =~ m/^\s*textarea\/{0,1}(\d*)\/{0,1}(\d*)/i)
    {
        my $cols = $1;
        my $rows = $2;
        my $disabled = '';
        $row_cont = '';
        if ( (defined $_->{DISABLED}) && ($_->{DISABLED} =~ m/^true$/i) ) {
            $disabled = 'disabled';
            $row_cont = "<input type='hidden' name='$field_name' value='$value'>\n";
        }
        $row_cont .=  "<textarea name='$field_name' wrap='virtual' $disabled cols=$cols rows=$rows>$value</textarea>";
    }   
    ######## LABEL
    elsif ($_->{HTMLTYPE} =~ m/^\s*label/i)
    {
        $color = '#ffffff';
        $row_span = 1;
        $row_name = $row_desc;
        $row_desc = '';
        $row_required = 0;
    }
    ######### TEXT
    elsif ($_->{HTMLTYPE} =~ m/^\s*text\/{0,1}(\d*)/i)
    {
         $row_cont = '';
         my $size = $1;
         my $disabled = '';
         if ((defined $_->{DISABLED}) && ($_->{DISABLED} =~ m/^true$/i)) {
            $disabled = 'disabled';
            $row_cont = "<input type='hidden' name='$field_name' value='$value'>\n";
         }
         $row_cont .= "<input name='$field_name' value='$value' $disabled size=$size>";
    }
    elsif ($_->{HTMLTYPE} =~ m/^\s*date\/{0,1}(\d*)/i)
    {
         my $size = $1;
         $row_cont = "<INPUT TYPE=\"text\" NAME=\"$field_name\" VALUE=\"$value\" SIZE=$size> <A HREF=\"#\" onClick=\"cal.select(document.forms['tick_form'].$field_name,'cal$field_name','MM/dd/yyyy'); return false;\" NAME=\"cal$field_name\" ID=\"cal$field_name\"><img src=\"/NoAuth/img/calendar-icon.gif\" alt=\"Select\"></img></A>";
    }    
    ######### PASSWORD
    elsif ($_->{HTMLTYPE} =~ m/^\s*password\/{0,1}(\d*)/i)
    {
         $row_cont = "<input type='password' name='$field_name' size=$1>";
    }
    ######### ATTACHMENTS
    elsif ($_->{HTMLTYPE} =~ m/^\s*attachment/i)
    {
        $template->param(ATTACHMENTS => 1);
        $template->param(COLOR => $color);
        $template->param(ROWNAME => $row_name);
        $template->param(REQUIRED => $row_required);
        $template->param(ROWDESC => $row_desc);
        next;
    }
    ######### DROPDOWN
    elsif ($_->{HTMLTYPE} =~ m/^\s*dropdown/i)
    {
        $row_cont = "<select name='$field_name'>";
        foreach (@values)
        {
        $row_cont .= "<option value=\'$_\'";
        $row_cont .= " selected " if $qry->param($field_name) eq $_;
        $row_cont .= ">$_</option>" . "\n" ;
        }
            $row_cont .= "</select>";
    }
    ######### MULTISELECT
    elsif ($_->{HTMLTYPE} =~ m/^\s*multiselect/i)
    {
        my $size = @values;
        $size = 5 if ($size > 5);

        $row_cont = "<select name='$field_name' size=$size multiple='multiple'>";
        my @user_values = $qry->param($field_name);
        my %selected;
        @{\%selected}{ @user_values } = @user_values;

        foreach (@values)
        {
            $row_cont .= "<option value=\'$_\'";
            $row_cont .= " selected " if defined($selected{$_});
            $row_cont .= ">$_</option>\n" ;
        }

        $row_cont .= "</select>";
    }
    ######### SELECT
    elsif ($_->{HTMLTYPE} =~ m/^\s*select/i)
    {
        my $size = @values;
        $size = 5 if ($size > 5);
        
            $row_cont = "<select name='$field_name' size=$size>";
        foreach (@values)
        {
        $row_cont .= "<option value=\'$_\'";
        $row_cont .= " selected " if $qry->param($field_name) eq $_;
        $row_cont .= ">$_</option>" . "\n" ;
        }
            $row_cont .= "</select>";
    }

    if (($_->{NAME} eq 'cclabel') ||
        ($_->{NAME} eq 'CC') ||
        ($_->{NAME} eq 'Login') || 
        ($_->{NAME} eq 'Password') || 
        ($_->{NAME} eq 'loginlabel')) {
                push(@ltemplate, {  SPAN => $row_span,
                                    COLOR => $color,
                                    ROWNAME => $row_name,
                                    REQUIRED => $row_required,
                                    ROWCONT => $row_cont,
                                    ROWDESC => $row_desc } ) ;  
    } else {
            push(@ttemplate, {  SPAN => $row_span,
                    COLOR => $color,
                                ROWNAME => $row_name,
                                REQUIRED => $row_required,
                                ROWCONT => $row_cont,
                                ROWDESC => $row_desc } ) ;
    }

        if ($color eq '#ffffff')
            { $color = '#eeeeee'; } 
        else 
            { $color = '#ffffff'; }

        $findex++;
    }

    # update the template
    $template->param(TICKET_LOOP => \@ttemplate);
    $template->param(LOGIN_LOOP => \@ltemplate);
    $template->param(display_form => 1);
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      gen_sessionid
# Description:  Generates session id
#                   
# Input:        
#   
# Returns:      $sessionid      
#-------------------------------------------------------------------------------------------------------------
sub gen_sessionid
{
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst)=localtime(time);

    "$$." . ($year+1900) . ($mon+1) . $mday . $hour . $min .$sec;
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      login_message
# Description:  Returns html code for login header
#                   
# Input:        
#   
# Returns:      
#-------------------------------------------------------------------------------------------------------------
sub login_message {
return <<MESSAGE;
        <tr> <td>&nbsp;</td> </tr>
        <tr> <td>&nbsp;</td> </tr>
<tr> <td align="left" colspan="2" bordercolor="#0" style="border-top-width:1; border-top-style: solid; border-bottom-width:1; border-bottom-style: solid; border-top: 1px solid #0; border-bottom: 1px solid #0; background-color: #ffffee;">
             <font size="4" color="#0">Sign the form using your Windows login.</td> </tr>
        <tr> <td>&nbsp;</td> </tr>
MESSAGE
}

sub cc_message {
return <<CC_MESSAGE;
    <tr> <td>&nbsp;</td> </tr>
    <tr> <td>&nbsp;</td> </tr>
    <tr> <td align="left" colspan="2" bordercolor="#0" style="border-top-width:1; border-top-style: solid; border-bottom-width:1; border-bottom-style: solid; border-top: 1px solid #0; border-bottom: 1px solid #0; background-color:         #ffffee;">
        <font size="4" color="#0">Add watchers to the ticket</td> </tr>
    <tr> <td>&nbsp;</td> </tr>
CC_MESSAGE
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      getCFvalue
# Description:  Return the value of asset's custom field
#                   
# Input:        Asset id, custom field name
#   
# Returns:      Array of CF values
#-------------------------------------------------------------------------------------------------------------
sub getCFvalue
{
    my ($id, $cf) = @_;
    my @rval = ( );

    my $asset = RTx::AssetTracker::Asset->new(RT::SystemUser);
    $asset->Load($id);
    my $values = $asset->CustomFieldValues($cf);

    while (my $value = $values->Next()) {
        push @rval, $value->Content;
    }
   
    @rval;
}

#-------------------------------------------------------------------------------------------------------------
# Routine:      getLargeCFvalue
# Description:  Same as getCFvalue, but works on large fields, like files
#                   
# Input:        Asset id, custom field name
#   
# Returns:      CF value
#-------------------------------------------------------------------------------------------------------------
sub getLargeCFvalue
{
    my ($id, $cf) = @_;
    my $asset = RTx::AssetTracker::Asset->new(RT::SystemUser);
    $asset->Load($id);
    return $asset->CustomFieldValues($cf)->Next()->LargeContent;
}

1;

