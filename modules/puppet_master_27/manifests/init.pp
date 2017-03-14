# puppet_master_27 class
class puppet_master_27 {
    require ruby, ruby::devel, ruby::libs, ruby::mysql
    require rubygems
    class { 'passenger' : conf_template => 'loglevel3.passenger.conf.erb', }
    require rails
    include puppet_master_27::packages
    include puppet_master_27::config
    include puppet_master_27::service
    include monit::puppet
    logrotate::rotate_logs_in_dir { 'puppet_master': directory => '/app/log/puppet', }
}
