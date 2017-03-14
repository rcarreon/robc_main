# adops php
class php::adops {
    class {'php::install': version => '5.3', ini_template => 'adops/php.ini-ao53u.erb'}

    case $::lsbmajdistrelease {
        6: {
            package {['php-mssql','php-mbstring','php-soap','php-phpunit-PHPUnit', 'php-process','php-pear-Net_GeoIP']:
                ensure  => present,
                require => Class['php::install'],
            }
        }
        5: {
            package {['php53u-mssql', 'php53u-mbstring','php53u-soap','php53u-phpunit-PHPUnit','php53u-process','php-pear-Net_GeoIP']:
                ensure  => present,
                require => Class['php::install'],
            }
        }
        default: {
            notifty { 'what OS are you running??? php::adops does not approve.... ': }
        }
    }
}
