#nginx vhost defined type
define nginx::vhost($virtual_template='',$vhost_list='',$dev='') {
    if $virtual_template != '' {
      $template = "nginx/conf.d/${project}/${virtual_template}.conf.erb"
    } else {
      $template = "nginx/conf.d/${project}/${name}.conf"
    }

    if $vhost_list == '' {
      $vhost = $name
    } else {
      $vhost = $vhost_list
    }

    file { "/etc/nginx/conf.d/${name}.conf":
        ensure  => file,
        owner   => root,
        group   => root,
        mode    => '0644',
        content => template($template),
        notify  => Exec['reload-nginx'],
        require => [ Package['nginx'], File['/etc/nginx/conf.d/virtual.conf'] ];
    }
}
