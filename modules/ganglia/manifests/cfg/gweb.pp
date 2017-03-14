# ganglia::cfg::gweb class for web interface
class ganglia::cfg::gweb ( $install = true ) {

    include "ganglia::data::${fqdn_vertical}"

    if ($install == true) {
        $ensureFile = 'present'
        $ensureDirectory = 'directory'
        $gmetadContent = template('ganglia/gmetad.conf.erb')
        $gmetadSysconfig = template('ganglia/gmetad.sysconfig.erb')
        $rrdcachedSysconfig = template('ganglia/rrdcached.sysconfig.erb')
        $gwebconfContent = template('ganglia/gweb-conf.php')

    # app/data for ganglia gweb only nodes

    file { '/app/data/ganglia':
        ensure => directory,
        owner  => 'root',
        mode   => '0755',
        require => Mount['/app/data/backup'],
        group  => 'root',
    }

    file { '/var/www/html/ganglia/graph.d/':
        ensure => 'directory',
        owner  => 'root',
        group  => 'root',
        mode   => '0755',
    }

    file { '/app/data/ganglia/conf':
        ensure  => directory,
        owner   => 'apache',
        group   => 'apache',
        mode    => '0775',
    }
    file { '/etc/ganglia/gmetad.conf':
        ensure  => $ensureFile,
        mode    => '0644',
        owner   => 'ganglia',
        group   => 'root',
        notify  => Service['gmetad'],
        content => $gmetadContent,
    }

    file { '/etc/sysconfig/gmetad':
        ensure  => $ensureFile,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        notify  => Service['gmetad'],
        content => $gmetadSysconfig
    }
    file { '/etc/sysconfig/rrdcached':
        ensure  => $ensureFile,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => $rrdcachedSysconfig
    }
    # html/ganglia stuff
    file { '/var/www/html/ganglia':
        ensure  => $ensureDirectory,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
    }
    file { '/var/www/html/ganglia/conf.php':
        ensure  => $ensureFile,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        content => $gwebconfContent,
    }

    file { '/var/www/html/ganglia/graph.d/nfslatency_report.php':
        ensure  => $ensureFile,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/ganglia/nfslatency_report.php',
        require => File['/var/www/html/ganglia/graph.d'],
    }

    file { '/app/data/ganglia/conf/default.json':
        ensure  => $ensureFile,
        mode    => '0664',
        owner   => 'apache',
        group   => 'apache',
        source  => 'puppet:///modules/ganglia/gweb-default.json',
    }

    file { '/app/data/ganglia/dwoo':
      ensure => 'directory',
      group  => '0',
      owner  => 'root',
      mode   => '0755',
    }
    file { [ '/app/data/ganglia/dwoo/cache', '/app/data/ganglia/dwoo/compiled']:
      ensure => 'directory',
      owner  => 'apache',
      group  => 'root',
      mode   => '0775',
    }
    file { '/app/data/ganglia/rrds':
      ensure  => 'directory',
      owner   => 'ganglia',
      mode    => '0775',
    }

} else {
        $ensureFile = 'absent'
        $ensureDirectory = 'absent'
        $gmetadContent = ''
        $gmetadSysconfig = ''
        $rrdcachedSysconfig = ''
        $gwebconfContent = ''
}

    # By default, gmetad starts way too early in the boot sequence.
    # We need it to start later on (specifically, after rrdcached)
    file { '/etc/chkconfig.d/gmetad':
        ensure  => $ensureFile,
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/ganglia/gmetad.chkconfig',
    }
    exec { 'chkconfigreset-gmetad':
        refreshonly  => true,
        subscribe    => File['/etc/chkconfig.d/gmetad'],
        command      => '/sbin/chkconfig gmetad resetpriorities',
        onlyif       => '/usr/bin/test -f /etc/rc.d/init.d/gmetad',
    }
}
