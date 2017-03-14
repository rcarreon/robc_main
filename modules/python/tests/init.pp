include python
include python::mysql
include python::mod_wsgi

# apparently there is a cross dependency to httpd::base ... so there ya go
include httpd::base
include python::install
