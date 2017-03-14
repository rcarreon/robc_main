# crowdignite's special nags
class nagios::check_url::crowdignite {

    nagios::check_url::chk_domain {'crowdignite.com': ip=>'97.64.84.119'}
    nagios::check_url::chk_uri {'crowdignite.com_':
        dom      => 'crowdignite.com',
        uri_path => '/',
        str      => 'href',
    }

    nagios::check_url::chk_domain {'crowdignite.momtastic.com': ip=>'97.64.84.119'}
    nagios::check_url::chk_uri {'crowdignite.momtastic.com_v_1112_219196172':
        dom      => 'crowdignite.momtastic.com',
        uri_path => '/v/1112/219196172',
        str      => 'href',
    }

    nagios::check_url::chk_login_form {'crowdignite.com_login':
        dom      => 'management.crowdignite.com',
        full_url => 'http://management.crowdignite.com/login',
        auth     => 'data[User][username]=nagios&data[User][password]=T3stL0gin',
        str      => 'Percentage of Traffic We Send Back to You',
    }

    nagios::check_url::chk_domain {'widget.crowdignite.com': ip=>'97.64.84.122'}
    nagios::check_url::chk_uri {'widget.crowdignite.com_widgets_17':
        dom      => 'widget.crowdignite.com',
        uri_path => '/widgets/17',
        str      => 'href',
    }

    # checkin all the contents, CI AZ 1107
    nagios::check_url::check_url_xml {'widget.crowdignite.com_widgets_17_xml':
        dom         => 'widget.crowdignite.com',
        full_url    => 'http://widget.crowdignite.com/widgets/17?content=xml',
        num_retries => '10',
    }
    nagios::check_url::check_url_xml {'widget.crowdignite.com_widgets_36_xml2':
        dom         => 'widget.crowdignite.com',
        full_url    => 'http://widget.crowdignite.com/widgets/36?content=xml2',
        num_retries => '10',
    }
    nagios::check_url::check_url_xml {'widget.crowdignite.com_widgets_36_xml_live':
        dom         => 'widget.crowdignite.com',
        full_url    => 'http://widget.crowdignite.com/widgets/36?content=xml_live',
        num_retries => '10',
    }

    nagios::check_url::chk_domain {'management.crowdignite.com': ip=>'97.64.84.121'}
    nagios::check_url::chk_uri {'management.crowdignite.com_':
        dom      => 'management.crowdignite.com',
        uri_path => '/',
        str      => 'href',
    }

    nagios::check_url::chk_domain {'crowdignite.craveonline.com': ip=>'97.64.84.119'}
    nagios::check_url::chk_uri {'crowdignite.craveonline.com_':
        dom      => 'crowdignite.craveonline.com',
        uri_path => '/',
        str      => 'href',
    }
    nagios::check_url::chk_uri_redirect {'crowdignite.momtastic.com_link_why_you_should_never_play_hide_and_seek':
        dom      => 'crowdignite.momtastic.com',
        uri_path => '/link/why_you_should_never_play_hide_and_seek/0/',
        str      => 'href',
    }
    nagios::check_url::chk_uri {'crowdignite.momtastic.com_why_you_should_never_play_hide_and_seek':
        dom      => 'crowdignite.momtastic.com',
        uri_path => '/why_you_should_never_play_hide_and_seek',
        str      => 'href',
    }
    nagios::check_url::json { 'crowdignite.com_rest_content_format_json':
        dom => 'crowdignite.com',
        url => 'http://crowdignite.com/rest/content?format=json&domain=0,5,6,11&type=popular&ranked=1&page=1&limit=12',
    } 
}
