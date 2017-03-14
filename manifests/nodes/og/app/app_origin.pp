# common configs for app-origin.og.prd servers
class origin::app_origin {

    include common::app
    include httpd

    # PHP stuff
    include yum::ius
	case $fqdn {
		 /app[0-9]+v-mgmt.og.prd/:{
			package {['php56u', 'php56u-cli', 'php56u-common', 'php56u-mcrypt', 'php56u-mysqlnd', 'php56u-mbstring','php56u-ldap','php56u-xml', 'php56u-gd','php56u-pdo','php56u-pecl-jsonc']: ensure => installed,}		
        	}
		/app[0-9]+v-origin.og.prd/ :{
			package {['php56u', 'php56u-cli', 'php56u-common', 'php56u-mcrypt', 'php56u-mysqlnd', 'php56u-mbstring','php56u-ldap','php56u-xml', 'php56u-gd','php56u-pdo','php56u-pecl-jsonc']: ensure => installed,} 
		}
		
		 default: {
			 package { ['php54', 'php54-cli', 'php54-common', 'php54-mcrypt', 'php54-mysql', 'php54-mbstring']: ensure => installed, } 
		}

	}

    file { '/app/log/laravel':
        ensure => directory,
        owner  => 'apache',
        group  => 'apache',
        mode   => '0755',
    }

    logrotate::rotate_logs_in_dir { 'laravel':
        directory => '/app/log/laravel',
    }
}

# common configs for app origin DEV servers
class origin::app_origin_dev {
        include common::app
        include httpd

        # PHP stuff
        include yum::ius
        package { ['php56u', 'php56u-cli', 'php56u-common', 'php56u-mcrypt', 'php56u-mysqlnd', 'php56u-mbstring']: ensure => installed, }

        file { '/app/log/laravel':
                ensure => directory,
                owner  => 'apache',
                group  => 'apache',
                mode   => '0755',
    }

    logrotate::rotate_logs_in_dir { 'laravel':
            directory => '/app/log/laravel',
    }
}
