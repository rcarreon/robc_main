# php dh class install stanza
class php::dh {
    class {'php::install': version => '5.1', ini_template => 'php.ini-dh.erb', extra_packages => ['php-mbstring', 'php-soap']}
}
