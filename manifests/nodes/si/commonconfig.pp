
class doublehelix::commonconfig::dev {
   file {"/app/shared/docroots/CommonConfig.php":
      ensure => file,
      owner  => "root",
      group  => "root",
      mode   => "0644",
      content => '<?php
class CommonConfig {
var $host = "sql1v-dh.si.dev.lax.gnmedia.net";
var $host_rw = "sql1v-dh.si.dev.lax.gnmedia.net";
var $host_ro = "sql1v-dh.si.dev.lax.gnmedia.net";
}
?>
',
   }
}

class doublehelix::commonconfig::stg {
   file {"/app/shared/docroots/CommonConfig.php":
      ensure => file,
      owner  => "root",
      group  => "root",
      mode   => "0644",
      content => '<?php
class CommonConfig {
var $host = "vip-sqlrw-dh.si.stg.lax.gnmedia.net";
var $host_rw = "vip-sqlrw-dh.si.stg.lax.gnmedia.net";
var $host_ro = "vip-sqlro-dh.si.stg.lax.gnmedia.net";
}
?>
',
   }
}

class doublehelix::commonconfig::prd {
   file {"/app/shared/docroots/CommonConfig.php":
      ensure => file,
      owner  => "root",
      group  => "root",
      mode   => "0644",
      content => '<?php
class CommonConfig {
var $host = "vip-sqlrw-dh.si.prd.lax.gnmedia.net";
var $host_rw = "vip-sqlrw-dh.si.prd.lax.gnmedia.net";
var $host_ro = "vip-sqlro-dh.si.prd.lax.gnmedia.net";
}
?>
',
   }
}

class doublehelix::commonconfig::localhost {
   file {"/app/shared/docroots/CommonConfig.php":
      ensure => file,
      owner  => "root",
      group  => "root",
      mode   => "0644",
      content => '<?php
class CommonConfig {
var $host = "localhost";
}
?>
',
   }
}

class ews::commonconfig::dev {
   file {"/app/shared/docroots/CommonConfig.php":
      ensure => file,
      owner  => "root",
      group  => "root",
      mode   => "0644",
      content => '<?php
class CommonConfig {
var $host = "vip-sqlrw-ews.si.dev.lax.gnmedia.net";
var $user_ro = "joomla_ews_ro";
var $password_ro = "fd2eRSt1";
}
?>
',
   }
}

class ews::commonconfig::stg {
   file {"/app/shared/docroots/CommonConfig.php":
      ensure => file,
      owner  => "root",
      group  => "root",
      mode   => "0644",
      content => '<?php
class CommonConfig {
var $host = "vip-sqlrw-ews.si.stg.lax.gnmedia.net";
var $user_ro = "joomla_ews_ro";
var $password_ro = "05agiaJU";
}
?>
',
   }
}

class ews::commonconfig::prd {
   file {"/app/shared/docroots/CommonConfig.php":
      ensure => file,
      owner  => "root",
      group  => "root",
      mode   => "0644",
      content => '<?php
class CommonConfig {
var $host = "vip-sqlrw-ews.si.prd.lax.gnmedia.net";
var $user_ro = "joomla_ews_ro";
var $password_ro = "dwKR99oz";
}
?>
',
   }
}


class sandbox::commonconfig::uid {
   file {"/app/shared/docroots/CommonConfig.php":
      ensure => file,
      owner  => "root",
      group  => "root",
      mode   => "0644",
      content => '<?php
class CommonConfig {
var $host = "localhost";
var $host_rw = "localhost";
var $host_ro = "localhost";
var $user_ro = "joomla_ews_ro";
var $password_ro = "47hucwAC";
}
?>
',
   }
}
