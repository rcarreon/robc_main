class tftpserver {

package { ["tftp-server"]:
        ensure => installed,
}

$tftp_xinetd_config='  
# THIS FILE IS OWNED BY PUPPET AND WILL BE OVERWRITTEN
  service tftp
  {
   	socket_type     = dgram
        protocol        = udp
        wait            = yes
        user            = root
        server          = /usr/sbin/in.tftpd
        server_args     = -c -s /app/shared/tftpboot
        disable         = no
        per_source	= 11
        cps             = 100 2
        flags           = IPv4
  }
'

 file { "/etc/xinetd.d/tftp":
        content => $tftp_xinetd_config,
        mode    => 0644,
        owner   => root,
        group   => root,
        require => Package["tftp-server"],
 }

}
