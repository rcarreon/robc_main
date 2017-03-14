# install monit
class monit {
    include monit::config
    include monit::service

    Package { before => Class['monit::config'] }

    case $::operatingsystem{
        centos:{
            package { 'monit':
                ensure => latest,
            }
        }
        default:{
            package { 'monit':
                ensure => present,
            }
        }
    }
}
