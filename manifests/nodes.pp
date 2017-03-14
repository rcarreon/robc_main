import "nodes/*/*.pp"
import "nodes/*/*/*.pp"

# default catch-all node for hosts with missing manifests
node 'default' {
    fail("Manifest is missing.")
}

# class for all tools that could help survive using the command line, note : do not include that class on production servers (pxy, web, sql) 
# as there is no reason to work directly from there, those tools are de facto useless
class common-tools {
    $common_packages = ["vim-common", "vim-enhanced", "strace", "bash-completion"]
    package { $common_packages:
        ensure => "present"
    }
}
