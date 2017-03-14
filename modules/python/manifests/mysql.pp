# python mysql class
class python::mysql inherits python {
    package { 'MySQL-python':
        ensure  => installed,
        require => Package ['python'],
    }
}
