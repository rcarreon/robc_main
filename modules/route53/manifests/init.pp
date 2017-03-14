# Class: route53

class route53 {
    include perl::xml_simple
    $aws_id=decrypt("z2eMxVosTLvNSEZRyOEfS9FJMizKmah188ZBBB1wFH0=")
    $aws_secret=decrypt("P68NjZUp7thy5c7N6GG+5nZ2oHoy4PSR3eSLXS8MjvtQbgqbZBD4FvbMs1DxKurV")

    package { ['python-lxml', 'perl-DNS-ZoneParse', 'perl-BIND-Conf_Parser',
	       'perl-WebService-Amazon-Route53', 'perl-Net-DNS', 'python-argparse', 'python-boto']:
        ensure => latest,
    }

    file { "/etc/boto.cfg":
        owner   => root,
        group   => root,
        mode    => 644,
        content => template("route53/boto.cfg.erb"),
    }
}
