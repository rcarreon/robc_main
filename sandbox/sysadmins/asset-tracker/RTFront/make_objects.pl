#!/usr/bin/perl

#
# This script creates AssetTracker objects
# required by QuickTicket. It is safe to rerun this
# multiple times. In case objects alread exist
# a warning is issued.
#

use lib '/opt/rt3/lib';
use RT::Interface::CLI qw(CleanEnv);
use RTx::AssetTracker;

# Clean the environment
CleanEnv();
    
# Load the RT configuration
RT::LoadConfig();
    
# Initialize RT
RT::Init();
    
# Create QuickTicket asset
my $asset_type = RTx::AssetTracker::Type->new(RT::SystemUser);
$asset_type->Load("QuickTicket");

if ($asset_type->id() == 0) {
    # Try creating types
    my ($id, $msg) = $asset_type->Create(
      'Name' => "QuickTicket",
      'Description' => "QuickTicket configuration assets",
      'Disabled' => false,
    );

    if ($id == 0) {
        print "Error: Failed to create QuickTicket asset type. Exitting.\n";
        exit(-1);
    }
} else {
    print "QuickTicket asset type already exists. Continuing...\n";
}

my $custom_fields = RT::CustomFields->new(RT::SystemUser);
$custom_fields->LimitToType($asset_type->id);

create_field_if_not_present( 
          'Repeated' => '0',
          'MaxValues' => '1',
          'Disabled' => '0',
          'Name' => 'TicketCategory',
          'SortOrder' => '0',
          'Description' => 'Ticket request category ',
          'Pattern' => '(?#Mandatory).',
          'Type' => 'Select',
          'QTAssetType' => $asset_type,
        );

create_field_if_not_present(
          'Repeated' => '0',
          'MaxValues' => '1',
          'Disabled' => '0',
          'Name' => 'TicketDestinationQueue',
          'SortOrder' => '0',
          'Description' => 'Destination queue for request ',
          'Pattern' => '(?#Mandatory).',
          'Type' => 'Freeform',
          'QTAssetType' => $asset_type,
        );

create_field_if_not_present(
          'Repeated' => '0',
          'MaxValues' => '1',
          'Disabled' => '0',
          'Name' => 'TicketSubmissionType',
          'SortOrder' => '0',
          'Description' => 'Method of routing the request ',
          'Pattern' => '',
          'Type' => 'Select',
          'QTAssetType' => $asset_type,
          'Values' => [ { Name => 'LoginOnPage', Description => 'Standart' }, 
                        { Name => 'Stop', Description => 'Don\'t show login at all (ticket cannot be submitted)'} ]
        );

create_field_if_not_present(
          'Repeated' => '0',
          'MaxValues' => '1',
          'Disabled' => '0',
          'Name' => 'TicketTemplateFile',
          'SortOrder' => '0',
          'Description' => 'XML file with template definition',
          'Pattern' => '',
          'Type' => 'Binary',
          'QTAssetType' => $asset_type,
        );

create_field_if_not_present(
          'Repeated' => '0',
          'MaxValues' => '0',
          'Disabled' => '0',
          'Name' => 'TicketSubCategory',
          'SortOrder' => '0',
          'Description' => 'Sub category for request (each category on a new line)',
          'Pattern' => '',
          'Type' => 'Freeform',
          'QTAssetType' => $asset_type,
        );

create_field_if_not_present(
          'Repeated' => '0',
          'MaxValues' => '1',
          'Disabled' => '0',
          'Name' => 'TicketSubCategoryOrder',
          'SortOrder' => '0',
          'Description' => 'Position of the ticket in the list',
          'Pattern' => '(?#Digits)^[\\d.]+$',
          'Type' => 'Freeform',
          'QTAssetType' => $asset_type,
        );

create_field_if_not_present(
          'Repeated' => '0',
          'MaxValues' => '1',
          'Disabled' => '0',
          'Name' => 'TicketSLA-Resolve',
          'SortOrder' => '0',
          'Description' => 'SLA: Time to resolve in businness hours',
          'Pattern' => '(?#Digits)^[\\d]+$',
          'Type' => 'Freeform',
          'QTAssetType' => $asset_type,
        );

create_field_if_not_present(
          'Repeated' => '0',
          'MaxValues' => '1',
          'Disabled' => '0',
          'Name' => 'TicketSLA-ACK',
          'SortOrder' => '0',
          'Description' => 'SLA: Time to acknowledge in business hours',
          'Pattern' => '(?#Digits)^[\\d]+$',
          'Type' => 'Freeform',
          'QTAssetType' => $asset_type,
        );

create_field_if_not_present(
          'Repeated' => '0',
          'MaxValues' => '1',
          'Disabled' => '0',
          'Name' => 'TicketBusinessHours',
          'SortOrder' => '0',
          'Description' => 'Business Hours that apply to this group of tickets - DO NOT EDIT',
          'Pattern' => '(?#Mandatory).',
          'Type' => 'Select',
          'QTAssetType' => $asset_type,
          'Values' => [ { Name => 'Normal', Description => '9 - 6 Mon - Fri (9 by 5)' },
                        { Name => 'Extended', Description => '7 - 7 Mon - Fri (12 by 5)'},
                        { Name => 'Critical', Description => '9 - 9 Sun - Sat (12 by 7)'},
                        { Name => 'Emergency', Description => '24 by 7 (Sun - Sat)'},
                      ]
        );

exit(0);

sub create_field_if_not_present() {
    my %args = @_;
    my $asset_type = $args{'QTAssetType'};
    my $values = $args{'Values'};
    delete $args{'QTAssetType'};
    delete $args{'Values'};
    my $custom_field = RT::CustomField->new(RT::SystemUser);
    $custom_field->Load($args{'Name'});
    if ($custom_field->id() == 0) {
        print "Creating custom field " . $args{'Name'} . "\n";
        my ($id, $msg) = $custom_field->Create(@_);
        if ($id == 0) {
            print "Failed to create field " . $args{'Name'} . "\n";
        }
        $custom_field->SetLookupType('RTx::AssetTracker::Type-RTx::AssetTracker::Asset');
    } else {
        print "Custom field " . $args{'Name'} . " alread exists\n";
    }

    # Assign values
    foreach my $value (@$values) {
        my $custom_field_value = RT::CustomFieldValue->new(RT::SystemUser);
        my $value_exists = 0;
        my $custom_field_values = $custom_field->Values();
        while (my $cfv = $custom_field_values->Next()) {
            $value_exists = 1 if ($cfv->Name() eq $value->{'Name'});
        }
        if ($value_exists == 0) {
            $value->{'CustomField'} = $custom_field->id();
            my ($id, $msg) = $custom_field_value->Create(%$value);
            if ($id == 0) {
                print "Error: could not create custom field value\n";
                exit(-1);
            } else {
                print "Created new custom field value: " . $value->{'Name'} . "\n";
            }
        } else {
            print "Value already exists: " . $value->{'Name'} . "\n";
        }
    }

    my ($id, $msg) = $custom_field->AddToObject($asset_type);
    if ($id == 0) {
        print "Warning: could not add custom field to QuickTicket type, reason: $msg\n";
    }
}
