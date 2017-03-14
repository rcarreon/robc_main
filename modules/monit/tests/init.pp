include monit
include monit::apache
include monit::collectd
include monit::puppet
include monit::dfp_scheduler
include monit::nft
include monit::openfire
include monit::xvfb

monit::stale_file_check { 'test check': 
    stale_file_abs_path => '/etc/passwd',
    stale_file_minutes  => '1800',
}
