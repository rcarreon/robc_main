# Class: ruby::rrdtool
#
# Sample Usage:
# include ruby::rrdtool
#
# This class may be unnecessary now that we disable
# rrdgraph on the puppetmasters
#
class ruby::rrdtool{
    package { 'ruby-RRDtool':
        ensure  => installed,
    }
    # ruby-rrdtool is not naming the .so as puppet expects it
    # http://groups.google.com/group/puppet-users/msg/2cd751e3b3d595e5
    file {'/usr/lib64/ruby/site_ruby/1.8/x86_64-linux/RRD.so':
        ensure  => link,
        target  => '/usr/lib64/ruby/site_ruby/1.8/x86_64-linux/RRDtool.so',
        require => Package['ruby-RRDtool'],
    }
}
