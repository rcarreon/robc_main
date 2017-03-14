# usage:

#       # script_path needs to be define first (if you use script_path.)  make sure to put script_path above "include cronjob".
#
#       $script_path="crowdignite_engine"
#       include cronjob
#
#      well, $script_path is optional and can be blank
#      default path of the script is /usr/local/bin/<script>
#      if there is a $script_path, it will put the script in /usr/local/bin/<$script_path>/<script>
#
# ex1: if we have 1 cron file, eng1.cron, which have multiple entries, ex. 10 entries, but 2 of those need to run .sh files
#
#      cronjob::do_cron_dot_d_cron_file {"eng1.cron": }
# add 2 extra .sh files
#      cronjob::do_cron_dot_d_script {"eng1_rebalance.sh":}
#      cronjob::do_cron_dot_d_script {"eng1_daily.sh":}
#
# ex2: if we have 1 cron file, ie. eng1_short.cron, which only have 1 entry and run 1 script,ie. eng1_short.sh,
#
#      cronjob::do_cron_dot_d {"eng1.cron": script => "eng1_short.sh", }
# or you can do it in 2 lines
#      cronjob::do_cron_dot_d_cron_file {"eng1.cron": }
#      cronjob::do_cron_dot_d_script {"eng1_short.sh":}
#
# ex3: if we have 1 cron file which run cmd somewhere that doesn't req extra script or the script is already exist
#
#      cronjob::do_cron_dot_d_cron_file {"eng1.cron": }
#
# ex4: if we wanna do anything other than cron.d, we would drop the script into /etc/cron.*
#      if we wanna put a script run_this_guy_everyday.sh into /etc/cron.daily
#
#      cronjob::do_cronjob {"run_this_guy_everyday.sh": cron_folder => "cron.daily"}



class cronjob {

  if $script_path != '' {
    file { "/usr/local/bin/${script_path}":
      ensure => directory,
      owner  => 'root',
      group  => 'root',
      mode   => '0644',
    }
  }
}
