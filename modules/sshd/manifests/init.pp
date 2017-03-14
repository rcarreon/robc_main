class sshd {

    case $::fqdn {
        /app[0-9]+v-preroll.sbv.prd/: {
            $passwordauth = 'yes'
        }
        default: {
            $passwordauth = 'no'
        }
   }
    case  $::fqdn {
                /app[1-9]+v-mal.ao.(prd|stg)/,/sql[1-6]+v-mal.ao.(prd|stg)/,/mem[1-2]+v-mal.ao.(prd|stg)/,/spx[1-2]+v-mal.ao.(prd|stg)/:{
			$sshdfile = 'sshd/sshd_config_mal.erb'
		}
		default:{ 
			$sshdfile = 'sshd/sshd_config.erb'
		}
   }
    package { 'openssh-server':
        ensure => present,
    }

    service { 'sshd':
        ensure    => running,
        enable    => true,
        hasstatus => true,
        require   => Package['openssh-server'],
    }

    file { '/etc/ssh/sshd_config':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        require => Package[openssh-server],
        notify  => Service[sshd],
        content => template($sshdfile)
    }

    # add default ssh_config
    file {'/etc/ssh/ssh_config':
        ensure  => file,
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
        source  => 'puppet:///modules/sshd/ssh_config',
        require => Package['openssh-server'],
    }

    # setup admin keys so they can't connect
    #as root when ldap is down
    file { 'ssh_directory':
        ensure => directory,
        path   => '/root/.ssh',
        owner  => 'root',
        group  => 'root',
        mode   => '0700',
    }
    file { '/root/.ssh/authorized_keys':
        ensure => absent,
    }

    # setup auth keys dir for sshd
    file { '/etc/ssh/keys' :
        ensure  => directory,
        mode    => '0444',
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/sshd/keys',
        recurse => true,
        purge   => true,
    }

    file { '/etc/ssh/keys/git':
        ensure => 'link',
        target => '/app/shared/git/.ssh/authorized_keys',
    }

}
