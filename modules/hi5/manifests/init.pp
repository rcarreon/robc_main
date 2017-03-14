# provides the hi5 script (aceman replacement)
class hi5 {
    include perl::hi5
    file { '/usr/local/bin/hi5':
        source => 'puppet:///modules/hi5/hi5',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

}
