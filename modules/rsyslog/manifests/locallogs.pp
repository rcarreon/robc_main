# class localogs

class rsyslog::locallogs {
   
   case $::fqdn {
        /app1v-mta.tp.prd.lax.gnmedia.net/: {
		file {'/etc/rsyslog.d/locallogs.conf':
	        source  => 'puppet:///modules/rsyslog/locallogs_mta1.conf',
        	owner   => 'root',
	        group   => 'root',
        	mode    => '0644',
	        require => File['/etc/rsyslog.d'],
        	notify  => Service['rsyslog'],
		}

        }
        /app2v-mta.tp.prd.lax.gnmedia.net/: {
                file {'/etc/rsyslog.d/locallogs.conf':
                source  => 'puppet:///modules/rsyslog/locallogs_mta2.conf',
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => File['/etc/rsyslog.d'],
                notify  => Service['rsyslog'],
                }

        }

        default: {
	        file {'/etc/rsyslog.d/locallogs.conf':
                source  => 'puppet:///modules/rsyslog/locallogs.conf',
                owner   => 'root',
                group   => 'root',
                mode    => '0644',
                require => File['/etc/rsyslog.d'],
                notify  => Service['rsyslog'],
                }

        }
    }
}
