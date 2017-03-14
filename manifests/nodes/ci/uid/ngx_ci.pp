class crowdignite::ngx_ci_uid {

    ### Common pkgs
    require crowdignite::app_ci_uid
    php::fpm {'nginx': pkgname => php54-fpm, }
    class {'nginx::install': config_template=>'crowdignite_widget_uid'}

    ### UID vhost declaration
    nginx::vhost {"${fqdn_type}.sbx.widget.crowdignite.com": virtual_template=>'uidspace.widget.crowdignite.com',dev=>$fqdn_type,vhost_list=>"${fqdn_type}.sbx.widget.crowdignite.com"}

    file {'/etc/nginx/conf.d/default.conf':
        ensure   => file,
        content  => template('nginx/conf.d/crowdignite/default.conf_uid.erb'),
        owner    => root,
        group    => root,
        mode     => '0644',
        require  => Package['nginx'],
    }
}
