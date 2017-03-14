# defined type for lvmount
define common::lvmount ( $vgname, $lvname, $atboot=yes,$fstype="ext3",$options="noatime" ) {
    exec {"vgenable-$vgname":
        command=>"/bin/bash -c '/sbin/pvscan;/sbin/vgscan;/sbin/vgchange -a y $vgname'",
        onlyif=>"/sbin/lvm lvdisplay $vgname | grep 'LV Status' | grep -q NOT",
    }
    exec {"mkdir-p-$name":
        command=>"/bin/mkdir -p $name",
        unless=>"/usr/bin/test -d $name"
    }

    mount {"$name":
        device=>"/dev/$vgname/$lvname",
        atboot=>"$atboot",
        fstype=>"$fstype",
        options=>"$options,_netdev",
        ensure=>"mounted",
        require=>[Exec["mkdir-p-$name"],Exec["vgenable-$vgname"]],
    }
}

