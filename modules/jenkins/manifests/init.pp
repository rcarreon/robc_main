# Class: jenkins
# Sample Usage:
#
class jenkins {

    include subversion::client

    $cidir = '/app/shared/hudson'

    # Add phab comment script to all hudson servers
    file { '/usr/local/bin/phab_post-run-comment.py':
        ensure => present,
        owner  => 'deploy',
        group  => 'deploy',
        mode   => '0755',
        source => 'puppet:///modules/jenkins/phab_post-run-comment.py',
    }

}
