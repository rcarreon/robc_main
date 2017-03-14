include rt
include rt::client
$rt_url = 'rt.gorillanation.com'
$qt_url = 'qt.gorillanation.com'
rt::config::rt_vhost {"$rt_url": db_host => "vip-sqlrw-rt.tp.prd.lax.gnmedia.net", db_user => "rt_user_rw", db_pass => "9Aul4dlQ", sso => true,}
rt::config::qt_vhost {"$qt_url": }
