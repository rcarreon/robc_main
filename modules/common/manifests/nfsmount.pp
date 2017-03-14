# defined type for nfsmount
define common::nfsmount (   
    $device,
    $options = "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp",
    $ensure = "mounted"
    ) {

    exec { "mkmountpoint-$name":
        command => "/bin/mkdir -p $name",
        cwd     => "/",
        before  => Mount["$name"],
        unless  => "/usr/bin/test -d $name"
    }
    mount { "$name":
        device  => $device,
        fstype  => "nfs",
        ensure  => $ensure,
        options => $options,
        atboot  => "true",
        dump    => 0,
        pass    => 0,
    }
}
