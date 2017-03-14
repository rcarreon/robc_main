# add rbenv configuration
class adops::rbenv {

    file { '/etc/profile.d/rbenv.sh':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        content => template('adops/rbenv.sh.erb'),
    }

}
