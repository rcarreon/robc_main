class vowpalwabbit::piddir {

    @file { '/var/run/vw':
        ensure  => directory,
        owner   => apache,
        group   => apache,
        mode    => 0755,
    }
    realize File['/var/run/vw']
}
