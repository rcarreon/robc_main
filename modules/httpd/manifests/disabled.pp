# Class httpd::disabled

class httpd::disabled inherits httpd::base {
    Service['httpd'] {
        enable  => false,
        ensure  => stopped,
    }
}
