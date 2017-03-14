#

#/modules/sysctl/manifests/sys_vm.pp
class sysctl::sys_vm {
  include sysctl
  conf {
    'vm.swappiness':                  value => 0;
    'vm.dirty_expire_centisecs':      value => 500;
    'vm.dirty_writeback_centisecs':   value => 100;
    'vm.dirty_ratio':                 value => 15;
    'vm.dirty_background_ratio':      value => 3;
    'vm.vfs_cache_pressure':          value => 10000;
  }
}

