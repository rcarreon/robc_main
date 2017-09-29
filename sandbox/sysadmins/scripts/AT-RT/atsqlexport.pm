package Infrastructure::AT;
# example at end of file
use DBI;
use strict;

sub new {
 my $class = shift;
 my $self = bless {}, ref($class) || $class;
 my %opts = @_;
 while (my ($k, $v) = each(%opts)) {
   $self->$k($v);
 }

 $self->getCustomFields;
 $self->getTypes;
 return $self;
}

for my $method (qw(server user pass)) {
 no strict 'refs';
 *{__PACKAGE__ . '::' . $method} = sub {
   my $self = shift;
   $self->{'_' . $method} = shift if @_;
   return $self->{'_' . $method};
 };
}

sub _login {
 my $self = shift;

 $self->{_db} = DBI->connect ( $self->{_server}, $self->{_user}, $self->{_pass} );
}

sub getCustomFields {
 my $self = shift;
 $self->_login unless $self->{_db};

 my $sql = "SELECT id, Name, MaxValues FROM CustomFields WHERE Disabled = 0";
 my $sth = $self->{_db}->prepare($sql);
 my $rcount = $sth->execute;

 my $k = $sth->fetchall_arrayref( { Name => 1, id => 1, MaxValues => 1 } );
 foreach (@$k) {
   $self->{cf}->{$_->{Name}} = $_->{id};
   $self->{maxval}->{$_->{Name}} = $_->{MaxValues};
 }

 return;
}

sub getTypes {
 my $self = shift;
 $self->_login unless $self->{_db};

 my $sql = "SELECT id, Name FROM AT_Types WHERE Disabled = 0";
 my $sth = $self->{_db}->prepare($sql);
 my $rcount = $sth->execute;

 my $k = $sth->fetchall_arrayref( { Name => 1, id => 1 } );
 foreach (@$k) {
   $self->{type}->{$_->{Name}} = $_->{id};
 }

 return;
}

# getAssets ( key => 'id', fields => \@array, where => { Rack => '1', Site => 'UK-HQ' } )
#   This function returns as hash of the assets that match the where values, hash includes fields specified in the array provided
#   If key is supplied, this asset field is used as the key for the returned hash
#   The above example will return a hash of all of the assets in Rack 1 in UK-HQ. @array = qw(Manufacturer AssetTag) would include the Manufacturer and AssetTag of each asset. The returned hash is indexed by the asset id number.

sub getAssets {
 my $self = shift;
 my %opts = @_;
 my $sep = '#@@#';

 my @k = ();

 $self->_login unless $self->{_db};

 if ($opts{where}) {
   if (ref($opts{where}) ne 'HASH') {
     print "getAssets called with non-hash parameter for 'where' option\n";
     return;
   }

   foreach my $name (keys %{ $opts{where} }) {
     if ($self->{cf}->{$name}) {
       push (@k, "id IN (SELECT ObjectId FROM ObjectCustomFieldValues WHERE CustomField = $self->{cf}->{$name} AND Content = '$opts{where}->{$name}' AND Disabled = 0)");
     } elsif ($name eq 'Type') {
       if (!$self->{type}->{$opts{where}->{$name}}) {
         print "Type '$opts{where}->{$name}' specified but is not a valid type.\n";
         next;
       }
       push (@k, "Type = '$self->{type}->{$opts{where}->{$name}}'");
     } elsif ($name eq 'Status') {
       push (@k, "Status = '$opts{where}->{$name}'");
     } elsif ($name eq 'Name') {
       push(@k, "Name = '$opts{where}->{$name}'");
     } else {
       print "Field '$name' requested but does not exist in AT\n";
       next;
     }
   }
 }

 if ($opts{wherelike}) {
   if (ref($opts{wherelike}) ne 'HASH') {
     print "getAssets called with non-hash parameter for 'notwhere' option\n";
     return;
   }

   foreach my $name (keys %{ $opts{wherelike} }) {
     if ( !$self->{cf}->{$name} && !grep(/\b$name\b/, qw(Name Status)) ) {
       print "CustomField '$name' requested but does not exist in AT. (1)\n";
       next;
     }
     if (grep(/\b$name\b/, qw(Name Status))) {
       push (@k, "$name LIKE '$opts{wherelike}->{$name}'");
     } else {
       push (@k, "id IN (SELECT ObjectId FROM ObjectCustomFieldValues WHERE CustomField = $self->{cf}->{$name} AND Content LIKE '$opts{wherelike}->{$name}' AND Disabled = 0)");
     }
   }
 } 

 if ($opts{notwhere}) {
   if (ref($opts{notwhere}) ne 'HASH') {
     print "getAssets called with non-hash parameter for 'notwhere' option\n";
     return;
   }

   foreach my $name (keys %{ $opts{notwhere} }) {
     if ( $self->{cf}->{$name} ) {
       push (@k, "id NOT IN (SELECT ObjectId FROM ObjectCustomFieldValues WHERE CustomField = $self->{cf}->{$name} AND Content = '$opts{notwhere}->{$name}' AND Disabled = 0)");
     } elsif ($name eq 'Type') {
       if (!$self->{type}->{$opts{notwhere}->{$name}}) {
         print "Type '$opts{notwhere}->{$name}' specified but is not a valid type.\n";
         next;
       }
       push (@k, "Type != '$self->{type}->{$opts{notwhere}->{$name}}'");
     } elsif ($name eq 'Status') {
       push (@k, "Status != '$opts{notwhere}->{$name}'");
     } else {
       print "CustomField '$name' requested but does not exist in AT. (2)\n";
       next;
     }
   }
 }

 my $where = join(" AND ", @k);
 @k = ();

 my $select = "";
 if ($opts{fields}) {
   if (ref($opts{fields}) ne 'ARRAY') {
     print "getAssets called with non-array parameter for 'fields' option\n";
     return;
   }
   foreach my $field ( @{ $opts{fields} } ) {
     if ( $self->{cf}->{$field} ) {
       $select .= ", (SELECT GROUP_CONCAT(Content SEPARATOR '$sep') FROM ObjectCustomFieldValues WHERE ObjectCustomFieldValues.CustomField = '$self->{cf}->{$field}' AND AT_Assets.id = ObjectCustomFieldValues.ObjectId AND ObjectCustomFieldValues.Disabled = 0) AS $field";
     } elsif ($field eq 'Type') {
       $select .= ", (SELECT Name FROM AT_Types WHERE AT_Types.id = AT_Assets.Type) AS Type";
     } elsif (grep(/\b$field\b/, qw(Name Description Status URI LastUpdated LastUpdatedBy Creator Created))) {
       $select .= ", $field";
     } else {
       print "CustomField '$field' requested but does not exist in AT. (3)\n";
       next;
     }
   }
 }

 my $sql = "SELECT id, (SELECT Name FROM AT_Types WHERE AT_Types.id = AT_Assets.Type) AS Type $select FROM AT_Assets WHERE $where";
 my $sth = $self->{_db}->prepare($sql);
 my $rcount = $sth->execute;

 my $k = $sth->fetchall_hashref($opts{key} || 'id');

 foreach my $id (keys %{ $k }) { 
   foreach my $val (keys %{ $k->{$id} }) {
     next unless (defined $self->{maxval}->{$val});
#      next unless (defined $self->{$id}->{$val});
     next if ($self->{maxval}->{$val} eq '1');
     my $original = $k->{$id}->{$val};
     $k->{$id}->{$val} = ();
     map push(@{$k->{$id}->{$val}}, $_), split(/$sep/, $original) if ($original);
   }
 }

 return $k;
}

#my $at = SZ::AT->new( server => 'DBI:mysql:rt3:rtserver:3306', user => 'user', pass => 'pass');
#
#my $fields = [ 'Name', 'Status', 'Rack', 'AssetTag', 'Slot', 'ConsoleAccess', 'Model', 'Type' ];
#my $wherelike = { ConsoleAccess => "\%ssh -p\%" };
#my $where = { Type => 'Server', Status => 'OutOfService' };
#$items = $at->getAssets(fields => $fields, where => $where );#, wherelike => $wherelike );
#
#print Dumper($items);

1;
