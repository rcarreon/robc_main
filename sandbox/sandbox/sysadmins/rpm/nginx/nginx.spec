%define nginx_user nginx
%define nginx_group %{nginx_user}
%define nginx_confdir %{_sysconfdir}/nginx
%define nginx_datadir %{_datadir}/nginx
%define nginx_webroot %{nginx_datadir}/html


Name: nginx
Summary: Robust, small and high performance http and reverse proxy server
Version: 0.6.34
Release: 3%{?dist}
Source0: %{name}-%{version}.tar.gz
License: GPL
Group: Web/Proxy
requires: zlib, zlib-devel, pcre, pcre-devel, openssl, openssl-devel
%description
Nginx [engine x] is an HTTP(S) server, HTTP(S) reverse proxy and IMAP/POP3 proxy server written by Igor Sysoev with integrated Fair connection management.
%prep
%setup -q
%build
# Fetch the fair-patch first : http://github.com/gnosek/nginx-upstream-fair/tree/master
./configure --prefix=/etc/nginx/ --conf-path=/etc/nginx/nginx.conf --error-log-path=/app/local/log/nginx/error.log --http-log-path=/app/local/log/nginx/access.log --pid-path=/var/run/nginx.pid --sbin-path=/sbin/nginx --with-http_ssl_module --add-module=/tmp/gnosek-nginx-upstream-fair --with-http_stub_status_module
make
%install
make install
%files
%defattr(-,nginx,nginx)
/sbin/nginx
/etc/nginx/
