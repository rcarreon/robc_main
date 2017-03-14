class openfire {

    package { 'java-1.6.0-openjdk':
        ensure => 'installed',
    }

    package { 'openfire':
        ensure  => 'installed',
        require => [ Package['java-1.6.0-openjdk'], File['/etc/sysconfig/openfire'] ],
    }

    file { '/etc/sysconfig/openfire':
        ensure => 'file',
        source => 'puppet:///modules/openfire/openfire.sysconfig',
        owner  => 'daemon',
        group  => 'daemon',
        mode   => '0644',
    }

    file { '/opt/openfire/plugins/admin/webapp/js/prototype.js':
        ensure  => 'file',
        source  => 'puppet:///modules/openfire/prototype.js',
        owner   => 'daemon',
        group   => 'daemon',
        require => Package['openfire'],
        notify  => Service['openfire'],
    }

    # This file has some odd whitespace requirements
    # if <setup>true</setup> does not have blank trailing whitespace,
    # openfire will rewrite it so it does on restart
    file { '/opt/openfire/conf/openfire.xml':
        ensure  => 'file',
        source  => 'puppet:///modules/openfire/openfire.xml',
        owner   => 'daemon',
        group   => 'daemon',
        require => Package['openfire'],
        notify  => Service['openfire'],
    }

    file { '/opt/openfire/resources/security/keystore':
        ensure  => 'file',
        source  => 'puppet:///modules/openfire/keystore',
        owner   => 'daemon',
        group   => 'daemon',
        mode    => '0644',
        require => Package['openfire'],
        notify  => Service['openfire'],
    }

    file { '/opt/openfire/resources/security/truststore':
        ensure  => 'file',
        source  => 'puppet:///modules/openfire/truststore',
        owner   => 'daemon',
        group   => 'daemon',
        mode    => '0644',
        require => Package['openfire'],
        notify  => Service['openfire'],
    }

    service { 'openfire':
        ensure    => 'running',
        enable    => true,
        hasstatus => true,
        require   => Package['openfire'],
    }
}
