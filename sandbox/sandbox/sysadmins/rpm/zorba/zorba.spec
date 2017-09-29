Name:    zorba
Version: 0.9.4
Release: 1%{?dist}
Summary: Zorba is a general purpose XQuery processor implementing in C++ the W3C family of specifications

Group: System Environment/Libraries
License: Apache v2
URL: http://www.zorba-xquery.com/
Source0: file://mirror.optus.net/sourceforge/z/zo/zorba/%{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


BuildRequires: cmake >= 2.4 libxml2 >= 2.2.16 icu >= 2.6 libicu
BuildRequires: boost >= 1.32 xerces-c >= 2.7


%description


%prep
%setup -q

%build
mkdir -p build
pushd build
cmake -D CMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Debug ..
make %{?_smp_mflags}
popd

%install
rm -rf $RPM_BUILD_ROOT
make install DESTDIR=$RPM_BUILD_ROOT INSTALL="install -p" -C build


%clean
rm -rf $RPM_BUILD_ROOT

%post 

/sbin/ldconfig
%postun 

/sbin/ldconfig


%files
%defattr(-,root,root,-)

%{_bindir}/%{name}
%{_includedir}/%{name}/%{name}/*.h
%{_libdir}/*.so.%{version}
%{_libdir}/*.so
%dir %{_datadir}/doc/%{name}-%{version}
/usr/include/zorba/simplestore/msdom/import.h
/usr/include/zorba/simplestore/simplestore.h
/usr/include/zorba/simplestore/simplestorec.h
/usr/include/zorba/zorba/util/file.h
/usr/include/zorba/zorba/util/path.h
/usr/lib/python2.4/site-packages/_zorba_api.so
/usr/lib/python2.4/site-packages/zorba_api.py
/usr/lib/python2.4/site-packages/zorba_api.pyc
/usr/lib/python2.4/site-packages/zorba_api.pyo
/usr/lib64/ruby/site_ruby/1.8/x86_64-linux/zorba_api.so
/usr/share/doc/zorba-0.9.4/c/examples/ccontext.c
/usr/share/doc/zorba-0.9.4/c/examples/cdatamanager.c
/usr/share/doc/zorba-0.9.4/c/examples/cerror.c
/usr/share/doc/zorba-0.9.4/c/examples/cexamples.c
/usr/share/doc/zorba-0.9.4/c/examples/cexternal_functions.c
/usr/share/doc/zorba-0.9.4/c/examples/cserialization.c
/usr/share/doc/zorba-0.9.4/c/examples/csimple.c
/usr/share/doc/zorba-0.9.4/c/html/rtab_b.gif
/usr/share/doc/zorba-0.9.4/c/html/rtab_l.gif
/usr/share/doc/zorba-0.9.4/c/html/rtab_r.gif
/usr/share/doc/zorba-0.9.4/cxx/examples/Makefile
/usr/share/doc/zorba-0.9.4/cxx/examples/chaining.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/context.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/datamanager.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/debugger.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/errors.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/examples.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/external_functions.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/simple.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/uri_resolvers.cpp
/usr/share/doc/zorba-0.9.4/cxx/html/rtab_b.gif
/usr/share/doc/zorba-0.9.4/cxx/html/rtab_l.gif
/usr/share/doc/zorba-0.9.4/cxx/html/rtab_r.gif
/usr/share/doc/zorba-0.9.4/python/examples/python_test.py
/usr/share/doc/zorba-0.9.4/python/examples/python_test.pyc
/usr/share/doc/zorba-0.9.4/python/examples/python_test.pyo
/usr/share/doc/zorba-0.9.4/python/html/rtab_b.gif
/usr/share/doc/zorba-0.9.4/python/html/rtab_l.gif
/usr/share/doc/zorba-0.9.4/python/html/rtab_r.gif
/usr/share/doc/zorba-0.9.4/ruby/examples/ruby_test.rb
/usr/share/doc/zorba-0.9.4/ruby/html/rtab_b.gif
/usr/share/doc/zorba-0.9.4/ruby/html/rtab_l.gif
/usr/share/doc/zorba-0.9.4/ruby/html/rtab_r.gif
/usr/share/doc/zorba-0.9.4/zorba/html/rtab_b.gif
/usr/share/doc/zorba-0.9.4/zorba/html/rtab_l.gif
/usr/share/doc/zorba-0.9.4/zorba/html/rtab_r.gif
/usr/share/doc/zorba-0.9.4/AUTHORS.txt
/usr/share/doc/zorba-0.9.4/LICENSE.txt
/usr/share/doc/zorba-0.9.4/NOTICE.txt
/usr/share/doc/zorba-0.9.4/README.txt
/usr/share/doc/zorba-0.9.4/cxx/examples/sax2.cpp
/usr/share/doc/zorba-0.9.4/cxx/examples/serialization.cpp

%changelog
