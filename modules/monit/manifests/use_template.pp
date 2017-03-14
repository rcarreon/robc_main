# put template from monit/templates into monit.d
# usage: monit::use_template { 'name_of_template_without_erb_ext': }
# ex:
# monit::use_template { 'vaquita_backup': }
# note: this requires monit/template/vaquita_backup.erb to exist
#        and will install it to /etc/monit.d/vaquita_backup.conf
define monit::use_template ( $template = "$name.erb" ) {
    require monit
    # i put in the conf, so it is found by monit.conf even if user forgets .conf
    file { "/etc/monit.d/$name.conf":
        ensure  => present,
        content => template("monit/$template"),
        notify  => Service['monit'],
        owner   => 'root',
        group   => 'root',
        mode    => '0644',
    }
}
