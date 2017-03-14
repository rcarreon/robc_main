class git::server {
    include git::client
    include httpd::ssl

    package { 'gitweb':
        ensure => present,
    }

    package { 'gitolite3':
        ensure => present,
    }

    file { '/app/shared/git/bin':
        ensure => directory,
        owner  => 'git',
        group  => 'git',
        mode   => '0750',
    }

    file { '/var/www/html/gitweb/gitweb.cgi':
        ensure  => 'present',
        owner   => 'git',
        group   => 'git',
        require => Package['gitweb'],
    }

    file { '/app/shared/git/bin/ldap-lookup':
        ensure => present,
        owner  => 'git',
        group  => 'git',
        mode   => '0750',
        source => 'puppet:///modules/git/ldap-lookup',
    }

    file { '/app/shared/git/.gitolite.rc':
        ensure => present,
        owner  => 'git',
        group  => 'git',
        mode   => '0750',
        source => 'puppet:///modules/git/gitolite.rc',
    }
    httpd::ssl::virtual_host { 'git.gnmedia.net':
        uri     => '/',
        monitor => false,
        require => File['/etc/httpd/conf.d/gd_bundle-g2-g1.crt']
    }

    file { '/etc/httpd/conf.d/gd_bundle-g2-g1.crt':
        owner    => 'root',
        group    => 'root',
        mode     => '0644',
        source   => 'puppet:///modules/git/gd_bundle-g2-g1.crt',
    }

    file { '/etc/httpd/conf.d/git.gnmedia.net.key':
        owner  => 'root',
        group  => 'root',
        mode   => '0600',
        source => 'puppet:///modules/httpd/certificates/git.gnmedia.net.key',
    }

    file { '/etc/gitweb.conf':
        owner  => 'root',
        group  => 'root',
        mode   => '0644',
        source => 'puppet:///modules/git/gitweb.conf',
    }

    file { '/etc/httpd/conf.d/git.gnmedia.net.crt':
        owner  => 'root',
        group  => 'root',
        mode   => '0600',
        source => 'puppet:///modules/httpd/certificates/git.gnmedia.net.crt',
    }

    file { '/app/shared/git':
        ensure   => directory,
        owner    => 'git',
        group    => 'git',
        mode     => '0755',
    }

    file { '/app/shared/gitolite':
        ensure   => directory,
        owner    => 'apache',
        group    => 'apache',
        mode     => '0755',
    }

    file { '/var/www/bin':
        ensure   => directory,
        owner    => 'apache',
        group    => 'apache',
        mode     => '0755',
    }

    # These hooks are only needed in prd
    if ($fqdn_env == 'prd') {

        # pre-receive hooks
        file { '/app/shared/git/repositories/puppet-modules.git/hooks/pre-receive':
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
            source => 'puppet:///modules/git/hooks/pre-receive-ldap-master',
        }

        file { ['/app/shared/git/repositories/configmgmt.git/hooks/pre-receive']:
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
            source => 'puppet:///modules/git/hooks/pre-receive-ldap',
        }

        file { ['/app/shared/git/repositories/puppet-manifests.git/hooks/pre-receive','/app/shared/git/repositories/puppet-templates.git/hooks/pre-receive']:
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
            source => 'puppet:///modules/git/hooks/pre-receive-puppet-ldap',
        }

        # post-receive hooks
        file { ['/app/shared/git/repositories/configmgmt.git/hooks/post-receive']:
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
            source => 'puppet:///modules/git/hooks/post-receive-email',
        }

        file { ['/app/shared/git/repositories/puppet-manifests.git/hooks/post-receive']:
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
            source => 'puppet:///modules/git/hooks/post-receive-puppet-manifests',
        }

        file { ['/app/shared/git/repositories/puppet-templates.git/hooks/post-receive']:
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
            source => 'puppet:///modules/git/hooks/post-receive-puppet-templates',
        }

        file { ['/app/shared/git/repositories/puppet-modules.git/hooks/post-receive']:
            owner  => 'root',
            group  => 'root',
            mode   => '0755',
            source => 'puppet:///modules/git/hooks/post-receive-puppet-modules',
        }
        git::jenkins_trigger {'test-copterize': 
            jenkins_viewname => 'CrowdIgnite',
            jenkins_jobname  => 'test-copterize',
            jenkins_token    => 'test-copterize-jenkins-build-token',
        }
    }
    # End of prd-only hooks

    # These hooks are used in both dev and prd
    file { '/usr/share/git-core/contrib/hooks/post-receive-email':
        mode   => '0755',
        source => 'puppet:///modules/git/post-receive-email',
        owner  => 'deploy',
        group  => 'deploy',
    }

    file { '/usr/share/git-core/contrib/hooks/ldap-perms':
        mode   => '0755',
        source => 'puppet:///modules/git/ldap-perms',
        owner  => 'root',
        group  => 'root',
    }

    file { '/usr/share/git-core/contrib/hooks/puppet-ldap-perms':
        mode   => '0755',
        source => 'puppet:///modules/git/puppet-ldap-perms',
        owner  => 'root',
        group  => 'root',
    }

    file { '/usr/share/git-core/contrib/hooks/puppet-syntax-ldap-perms':
        mode   => '0755',
        source => 'puppet:///modules/git/puppet-syntax-ldap-perms',
        owner  => 'root',
        group  => 'root',
    }

    file { '/var/www/html/gitweb':
        ensure => directory,
        owner  => git,
        group  => git,
        mode   => 0755,
    }

    file { '/usr/sbin/suexec':
        ensure => present,
        owner  => root,
        group  => root,
        mode   => 4755,
    }

    # we bind mount /usr/share/gitweb, where the gitweb.cgi exists,
    # to /var/www/html/gitweb so we can run suexec, which is 
    # copmiled with /var/www as the docroot, 
    # it won't allow execution from a different path
    mount { '/var/www/html/gitweb':
        ensure  => mounted,
        device  => '/usr/share/gitweb',
        fstype  => 'none',
        options => 'rw,bind',
        require => [Package['gitweb'],
                    File['/var/www/html/gitweb']],
    }

    file { '/var/www/bin/gitolite-suexec-wrapper.sh':
        ensure => present,
        source => 'puppet:///modules/git/gitolite-suexec-wrapper.sh',
        owner  => root,
        group  => root,
        mode   => 0755,
    }

    file { '/etc/httpd/conf.d/git.conf':
        ensure => present,
        source => 'puppet:///modules/git/git.conf',
        owner  => root,
        group  => root,
        mode   => 0755,
    }

}
