
# usage
#
# 1.  create "class nagios::check_url_xxxxx"
# 2.  call chk on the nagios boxes manifest by "include nagios::check_url_xxxxx"

# there are a few chk, pls see ex below.
#
# first, we have to do 'chk_domain' which will 'define host' and ping it ip
#    chk_domain {"crowdignite.com": ip=>'72.172.76.148'}

# then, we can chk url like below, notice we replace / with _ on the 'name'
#
#    chk_uri {"crowdignite.com_": dom=>'crowdignite.com',uri_path=>'/',str=>'href'}
#    chk_uri {"crowdignite.com_v_338_439416": dom=>'crowdignite.com',uri_path=>'/v/338/439416',str=>'href'}

#    chk_login_form {"crowdignite.com_login": dom=>'crowdignite.com',full_url=>'http://crowdignite.com/login',auth=>'data[User][username]=moby&data[User][password]=d1Ck4u',str=>'Percentage of Traffic We Send Back to You'}
class nagios::check_url {
    include nagios::check_url::crowdignite
}
