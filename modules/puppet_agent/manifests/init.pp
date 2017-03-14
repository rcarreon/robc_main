# install puppet agent
class puppet_agent {
    include puppet_agent::packages
    include puppet_agent::config
    include puppet_agent::service
    include monit::puppet
}
