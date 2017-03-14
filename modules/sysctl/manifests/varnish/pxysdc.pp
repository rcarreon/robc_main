# $Id$
# $URL$

# /modules/sysctl/manifests/varnish/pxysdc.pp
sysctl::conf { 'vm.vfs_cache_pressure': value => '100'; }

