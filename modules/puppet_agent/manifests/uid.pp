# use this to override config for uid boxes
# to set report = false to prevent errors in email and foreman
class puppet_agent::uid inherits puppet_agent::config {
    File ['/etc/puppet/puppet.conf'] {
        ensure  => file,
        content => template('puppet_agent/puppet_uid.conf.erb'),
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
