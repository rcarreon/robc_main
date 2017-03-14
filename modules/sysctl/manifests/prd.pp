#

# /modules/sysctl/manifests/prd.pp
class sysctl::prd {
  include sysctl
  # conf {'net.core.somaxconn': value => '128' }
}

