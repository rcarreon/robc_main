AC_INIT(rnetapp, 2.33)
AM_INIT_AUTOMAKE

AC_PATH_PROGS(PERL,[$PERL perl])

AC_MSG_CHECKING([for ONTAPI perl module])
if $PERL  -e 'BEGIN { map { -d "$_/NetApp" && unshift(@INC,"$_/NetApp") } @INC; }; use NaServer;exit' 2>/dev/null;then
   AC_MSG_RESULT([yes])
else
   AC_MSG_RESULT([no])
   AC_MSG_WARN([***])
   AC_MSG_WARN([*** rnetapp will not run without ONTAPI.])
   AC_MSG_WARN([***  See README for information.])
   AC_MSG_WARN([***])
fi
AC_MSG_CHECKING([for Net::IP perl module])
if $PERL -e 'use Net::IP; exit' 2>/dev/null;then
   AC_MSG_RESULT([yes])
else
   AC_MSG_RESULT([no])
   AC_MSG_WARN([***])
   AC_MSG_WARN([*** rnetapp will not run without Net::IP.])
   AC_MSG_WARN([***  See README for information.])
   AC_MSG_WARN([***])
fi

AC_CONFIG_FILES([Makefile rnetapp.spec])
AC_OUTPUT

cat $srcdir/ChangeLog >> rnetapp.spec
