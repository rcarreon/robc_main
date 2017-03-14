# provides the aceman script with permissions usable by nagios
class aceman::nagios inherits aceman {
    File['/etc/acemanrc'] {
        owner => 'nagios',
    }
}
