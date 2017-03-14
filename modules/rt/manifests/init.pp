# how it works
# rt pkg will install files into /usr/share/rt3
# since there are a lot of code hack such as quickticket (gn homemade) which looks for rt in /usr/local/lib/rt3
# the workaround is to put rt code into svn which will be pulled down into /app/shared/rt3
# then we symlink, ln -s /usr/share/rt3 /app/shared/rt3, ln -s /usr/local/lib/rt3 /app/shared/rt3 which are done in rt::install 
# we ensure present on rt pgk (rt::install) which will install into /usr/share/rt3 which will override/upgrade /app/shared/rt3.
# if we are sure everything is working with the new pkg, we can svn commit to get the new code into our svn

# usage
# on the manifest

#        $rt_url = 'rt.gorillanation.com'
#        $qt_url = 'qt.gorillanation.com'

#        include rt
#        rt::config::rt_vhost {"$rt_url": db_host => "vip-sqlrw-rt.tp.prd.lax.gnmedia.net", db_user => "someusername", db_pass => "imnotgonnatellu", sso => true,}
#        rt::config::qt_vhost {"$qt_url": }

# ex2. inventory severs

#    	$rt_url = 'inventory.gnmedia.net'
#    	$qt_url = 'tracker.gnmedia.net'

class rt {
  # we don't need firstrun which does installation, we put all the code on svn in /app/share
  # we leave it here just for ref in case we need to install from scratch
  # include rt::install, rt::config, rt::jobs, rt::firstrun
  include rt::install, rt::config, rt::jobs
}
