# Class: jenkins::server
class jenkins::server inherits jenkins {

    case $::lsbmajdistrelease {
    6:  {
        # moved to node scope because dynamic scoping dies in puppet 3.x
        # $httpd='cijoe'
        # $project='ci'
        include httpd
        httpd::virtual_host {'ic.gnmedia.net':}

        # Data store for job and workspace
        file {'/app/shared/jenkins':
            ensure  => directory,
            owner   => 'deploy',
            group   => 'deploy',
            mode    => '0775',
        }
    }

    default: {
        fail("Module ${module_name} is not supported on ${::lsbmajdistrelease}")
    }

  }
}
