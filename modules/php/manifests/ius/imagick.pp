# php 54 imagick class
class php::ius::imagick {
    package { ['php54-pecl-imagick', 'ImageMagick']:
        ensure => installed,
    }
}
