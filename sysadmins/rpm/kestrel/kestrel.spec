%define app_prefix	/usr/local/kestrel

Name:		kestrel
Version:	2.3.1
Release:	2%{?dist}
Summary:	A simple, distributed message queue system

Group:		Applications/Internet
License:	Apache 2
URL:		https://github.com/robey/kestrel
Source0:	%{name}-%{version}.zip
Source1:    %{name}_init.sh
BuildRoot:	%(mktemp -ud %{_tmppath}/%{name}-%{version}-%{release}-XXXXXX)
BuildArch:	noarch

#BuildRequires:	
#Requires:	

%description
Kestrel is a simple, distributed message queue written on the JVM, 
based on Blaine Cook's "starling".  

Each server handles a set of reliable, ordered message queues, with 
no cross communication, resulting in a cluster of k-ordered ("loosely 
ordered") queues. Kestrel is fast, small, and reliable.

%prep
%setup -q
cp -p %SOURCE1 .

%build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{app_prefix}/%{name}-%{version}
mkdir -p %{buildroot}/etc/rc.d/init.d
mv -f %{name}_init.sh scripts
mv -f * %{buildroot}/%{app_prefix}/%{name}-%{version}
cp  %{buildroot}/%{app_prefix}/%{name}-%{version}/scripts/%{name}_init.sh %{buildroot}/etc/rc.d/init.d/%{name}

%clean
rm -rf %{buildroot}

%files
%defattr(0755,root,root,0755)
%{app_prefix}
/etc/rc.d/init.d/%{name}

%post
/sbin/chkconfig --add kestrel
%preun
if [ $1 = 0 ] ; then
    /sbin/service kestrel stop >/dev/null 2>&1
    /sbin/chkconfig --del kestrel
fi

%changelog
* Tue Aug 7 2012 Chris Haggstrom <chris.haggstrom@gorillanation.com> - 2.3.1-2
- Added init script and chkconfig post/preun scripts.
* Mon Aug 6 2012 Chris Haggstrom <chris.haggstrom@gorillanation.com> - 2.3.1-1
- Initial release.
