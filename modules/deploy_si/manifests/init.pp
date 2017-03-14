

class deploy_si {

    $sibuildpw=decrypt('+i1v4NQDtimTyOyeoAFx5g==')


    file { '/etc/si_build':
        ensure  => 'directory',
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }

    file { '/etc/si_build/si_build.my.cnf':
        ensure  => 'present',
        owner   => 'root',
        group   => 'root',
        mode    => '0640',
        content => template('deploy_si/si_build.my.cnf.erb'),
        require => File['/etc/si_build'],
    }

}
