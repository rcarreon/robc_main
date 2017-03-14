# defined type for ugcmount
define common::ugcmount (
    $device,
    $options = "nfsvers=3,noatime,rw,rsize=32768,wsize=32768,noexec,nosuid,hard,intr,tcp"
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
        ensure  => "mounted",
        options => $options,
        atboot  => "true",
        dump    => 0,
        pass    => 0,
    }
}
