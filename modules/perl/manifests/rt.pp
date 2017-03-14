# Perl classes for rt
class perl::rt {
    require ::perl
    package { ['perl-TermReadKey', 'perl-Crypt-SSLeay', 'perl-libwww-perl']:
        ensure  => installed,
        require => Package['perl'],
    }
}
