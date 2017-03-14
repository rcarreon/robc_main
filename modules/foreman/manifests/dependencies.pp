# Class: foreman::dependencies

class foreman::dependencies {
    $project = 'puppet'
    include passenger
    include subversion::client
    class { 'mysqld56::client': } ->
    package { 'ruby-mysql': ensure => installed, }

    $extra_packages = ['rubygem-rest-client', 'rubygem-mime-types']
    package{$extra_packages:
        ensure => installed,
    }
}
