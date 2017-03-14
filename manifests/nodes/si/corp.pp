class si::corp_sites {
    include httpd
    #include php::dh
    include subversion::client
    if ($::fqdn_env == 'dev') {
        include php::si_54
    }else{
        include php::dh
    }

    httpd::virtual_host {"www.evolvemediallc.com": uri => '/home', expect => 'Evolve',}
    #httpd::virtual_host {"www.totallyhermedia.com": uri => '/', expect => 'Evolve',}
    httpd::virtual_host {"www.globetrottingonline.com": uri => '/', expect => 'home_com_content_evolve',}
}
