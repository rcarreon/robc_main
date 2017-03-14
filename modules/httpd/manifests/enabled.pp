# Class httpd::enabled

class httpd::enabled inherits httpd::base {
    Service['httpd'] {
        enable  => true,
        ensure  => running,
    }
}
