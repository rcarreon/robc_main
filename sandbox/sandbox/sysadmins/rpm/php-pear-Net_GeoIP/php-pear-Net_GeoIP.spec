
%define pear_dir %(pear config-get php_dir 2>/dev/null || echo %{_datadir}/pear)
%define xml_dir  %{peardir}/.pkgxml

Name: php-pear-Net_GeoIP
Version: 1.0.0
Summary: PEAR package for Net_GeoIP
Release: RC1
License: BSD
Group: Development/Languages
URL: http://pear.php.net/package/Net_GeoIP/
Source0: http://download.pear.php.net/package/Net_GeoIP-%{version}%{release}.tgz
Packager: Eric Welsh <ericwelsh@yahoo.com>
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root
BuildArch: noarch
Requires: php-pear
Requires:      php-common
BuildRequires: php-pear

%description



%prep


%install
%{__rm} -rf %{buildroot}
pear install -R %{buildroot} -n %{SOURCE0}
# Remove these hidden files, we don't want to include those
%{__rm} -rf %{buildroot}%{pear_dir}/{.channels,.depdb*,.filemap,.lock,.registry}

%{__mkdir_p} %{buildroot}%{xml_dir}
%{__tar} -xzvf %{SOURCE0} package.xml
%{__cp} -a package.xml %{buildroot}%{xml_dir}/Net_GeoIP.xml


%clean
%{__rm} -rf %{buildroot}


%post
pear install --nodeps --soft --force --register-only \
    %{xmldir}/Net_GeoIP.xml &>/dev/null || :

%postun
if [ $1 -eq 0 ]; then
    pear uninstall --nodeps --ignore-errors --register-only \
        Date &>/dev/null || :
fi


%files
%defattr(0644, root, root, 0755)
%{pear_dir}/*


%changelog
