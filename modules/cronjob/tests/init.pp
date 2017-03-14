$script_path='test'
include cronjob
cronjob::do_cron_dot_d_cron_file {'test.cron': }
cronjob::do_cron_dot_d_script {'test.sh':}
