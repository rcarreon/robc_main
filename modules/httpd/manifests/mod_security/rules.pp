# Class httpd::rules

    define httpd::mod_security::rules($static = 'enabled', $dynblock = 'enabled', $website = $name) {
        case $static {
            default, 'enabled': {
                file { '/etc/httpd/modsecurity.d/activated_rules':
                    ensure  => directory,
                    source  => "puppet:///modules/httpd/modsecurity.d/${project}/${website}/activated_rules",
                    mode    => '0644',
                    recurse => true,
                    purge   => true,
                    force   => true,
                    owner   => 'root',
                    group   => 'root',
                    require => File['/etc/httpd/modsecurity.d'],
                    ignore  => '.svn'
                }
            }
            'disabled': {
                file { '/etc/httpd/modsecurity.d/activated_rules':
                    ensure  => directory,
                    mode    => '0644',
                    recurse => true,
                    purge   => true,
                    force   => true,
                    owner   => 'root',
                    group   => 'root',
                    require => File['/etc/httpd/modsecurity.d'],
                }
            }
        }

        case $dynblock {
            default, 'enabled': {
                file { '/etc/httpd/modsecurity.d/switched_rules/dyn_blocking.conf':
                    ensure  => present,
                    source  => "puppet:///modules/httpd/modsecurity.d/${project}/${website}/switched_rules/dyn_blocking.conf",
                }
            }
            'disabled': {
                file { '/etc/httpd/modsecurity.d/switched_rules/dyn_blocking.conf':
                    ensure => absent,
                }
            }
        }
}
