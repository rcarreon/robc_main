# php service type class ...
class php::service_type {
    if $service_type == '' {
        $service_type = httpd
    }

    if $service_type == 'httpd' {
        include $service_type
    }
}
