# puppet-lint made me do this
class php::ap_mediaads {
    class {'php::install': version => '5.3', ini_template => 'adops/php.ini-ap-mediaads.erb'}
}
