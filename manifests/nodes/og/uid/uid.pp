# common configs for uid.og.dev servers
class origin::uid {

    include common::app
    include httpd
    include git::client

    # PHP stuff
    include yum::ius
   case $fqdn {
	/uid[0-9]+v-pmilosevic.og.dev/:{
		package {['php56u', 'php56u-cli', 'php56u-common', 'php56u-mcrypt', 'php56u-mysqlnd', 'php56u-mbstring','php56u-ldap','php56u-xml', 'php56u-gd','php56u-pdo','php56u-pecl-jsonc']: ensure => installed,}
	}
	default:{
		    package { ['php54', 'php54-cli', 'php54-common', 'php54-mcrypt', 'php54-mysql']: ensure => installed, }
	}
   }
    # no template in modules yet
    httpd::virtual_host {'uid.dev.originplatform.com': monitor => false }
    httpd::virtual_host {'redirs.originplatform.com': monitor => false }

    logrotate::rotate_logs_in_dir { 'laravel':
        directory => '/app/log/laravel',
    }

    file { '/app/log/laravel':
        ensure => directory,
        owner  => 'apache',
        group  => 'apache',
        mode   => '0755',
    }
}
