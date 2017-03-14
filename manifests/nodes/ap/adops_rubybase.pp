# add base ruby packages
class adops::rubybase {

    package { ['rubygems', 'rubygem-bundler']:
        ensure => installed,
    }

    if ($::fqdn_role != 'uid' and $::fqdn != 'app1v-pubops-martini.ap.prd.lax.gnmedia.net' and $::fqdn != 'app2v-pubops-martini.ap.prd.lax.gnmedia.net'  ) {
        package { ['mysql-libs.x86_64']:
            ensure => installed,
        }
    }

}
