#taken from dev.adops.gorillanation.com to include tests coverage

# required in 000-default.conf template
$logcomm = '#'
include httpd
httpd::virtual_host {'000-default.conf': uri => '/sessions/login', expect => 'forgot your password'}
