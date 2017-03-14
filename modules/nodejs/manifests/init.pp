# Class: nodejs
#
# first we need to get the repo installed locally
class nodejs {
#  include yum::nodejs-live
#  We now use EPEL packages instead of a local nodejs repo
  $packages_nodejs = ['npm',]
  package{$packages_nodejs:
    ensure  => installed,
  }

}
