# origin's special nags
class nagios::check_url::origin {

    nagios::check_url::chk_domain {'originplatform.com': ip=>'97.64.84.117'}
    nagios::check_url::chk_uri {'originplatform.com_':
        dom      => 'originplatform.com',
        uri_path => '/',
        str      => 'href',
    }
}
