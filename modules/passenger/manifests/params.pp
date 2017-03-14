# Class: passenger::params
# This class manages parameters for the Passenger module
#
# Sample Usage:
#
class passenger::params ( $passenger_version = '2.2.15' ) {
    $version = $passenger_version
    $gem_path = '/usr/lib/ruby/gems/1.8/gems'
    $gem_binary_path = '/usr/lib/ruby/gems/1.8/gems/bin'
    $mod_passenger_location = "/usr/lib/ruby/gems/1.8/gems/passenger-${version}/ext/apache2/mod_passenger.so"

}
