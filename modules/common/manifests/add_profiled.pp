# add a file to /etc/profile.d
# example common::add_profiled { 'vaquita_pythonpath.sh': }
define common::add_profiled {
    file { "/etc/profile.d/$name":
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
        source => "puppet:///modules/common/$name",
    }
}
