# New class to determine if /home should be mounted

class common::mounthome (
    $device = 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_home/home',
    $options = 'nfsvers=3,tcp,noatime,rw,rsize=32768,wsize=32768,hard,intr,tcp,nosuid,nodev',
    ) {

    $mountopt = $::at_homemount

    # List of networks allowed to mount home.  Overrides should be
    # handled in AT custom field HomeMount.  Please try to keep networks in order.
    $network_whitelist = [ '10.11.20.0',  # TP PRD
                            '10.11.120.0', # TP STG
                            '10.11.220.0', # TP DEV
                            '10.11.226.0', # SI DEV
                            '10.11.228.0', # SBV DEV
                            '10.11.230.0', # AP DEV
                            '10.11.234.0', # AO DEV
                            '10.11.236.0', # OG DEV
                            '10.12.20.0',  # TP PRD INT
                            '10.12.120.0', # TP STG INT
                            '10.12.220.0', # TP DEV INT
                            '10.12.26.0',  # SI PRD INT
                            '10.12.126.0', # SI STG INT
                            '10.12.226.0', # SI DEV INT
                            '10.12.28.0',  # SBV PRD INT
                            '10.12.128.0', # SBV STG INT
                            '10.12.228.0', # SBV DEV INT
                            '10.12.30.0',  # AP PRD INT
                            '10.12.130.0', # AP STG INT
                            '10.12.230.0', # AP DEV INT
                            '10.12.34.0',  # AO PRD INT
                            '10.12.134.0', # AO STG INT
                            '10.12.234.0', # AO DEV INT
                            '10.12.36.0',  # OG PRD INT
                            '10.12.136.0', # OG STG INT
                            '10.12.236.0', # OG DEV INT
                          ]

    # We'll take the ensure parameter if supplied.  If not supplied,
    # check to see if network is in whitelist, if so mount /home.
    if $mountopt == '' {
        if $::network_eth0 in $network_whitelist {
            $ensure = 'mounted'
            $mountdevice = 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_home/home'
        } else {
            $ensure = 'mounted'  
            $mountdevice = 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_homeext/home'
        }
    } else {
        if $mountopt == 'external' {
            $ensure = 'mounted'
            $mountdevice = 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_homeext/home'
        } elsif $mountopt == 'middle' {
            $ensure = 'mounted'
            $mountdevice = 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_homemid/home'
        } elsif $mountopt == 'internal' {
            $ensure = 'mounted'
            $mountdevice = 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_home/home'

        # These are temp compat values. 
        } elsif $mountopt == 'transitional' {
            $ensure = 'mounted'
            $mountdevice = 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_hometrans/home'
        } elsif $mountopt == 'mounted' {
            $ensure = 'mounted'
            $mountdevice = 'nfsA-netapp1.tp.prd.lax.gnmedia.net:/vol/nac1a_home/home'
        } else {
            fail('MountHome in inventory has an ugly value.  Make it pretty.')
        }
    }

    common::nfsmount { '/home':
                        ensure  => $ensure,
                        device  => $mountdevice,
                        options => $options,
    }

}
