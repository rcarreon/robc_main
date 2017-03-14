Exec { path => "/usr/bin:/usr/sbin:/bin:/sbin" }
stage { "pre": before => Stage["main"] }

import "nodes.pp"
# Turn all http logging on or off!
# BE CAREFUL!
$defaulthttpdlogging = true

# This is a test comment
# EZ vars
$fqdn_role=regsubst($fqdn,     '^(\D+)(\d+)(v|p)-(\S+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)$', '\1')
$fqdn_incr=regsubst($fqdn,     '^(\D+)(\d+)(v|p)-(\S+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)$', '\2')
$fqdn_hardware=regsubst($fqdn, '^(\D+)(\d+)(v|p)-(\S+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)$', '\3')
$fqdn_type=regsubst($fqdn,     '^(\D+)(\d+)(v|p)-(\S+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)$', '\4')
$fqdn_vertical=regsubst($fqdn, '^(\D+)(\d+)(v|p)-(\S+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)$', '\5')
$fqdn_env=regsubst($fqdn,      '^(\D+)(\d+)(v|p)-(\S+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)$', '\6')
$fqdn_loc=regsubst($fqdn,      '^(\D+)(\d+)(v|p)-(\S+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)$', '\7')
$fqdn_domain=regsubst($fqdn,   '^(\D+)(\d+)(v|p)-(\S+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)\.(\D+)$', '\8.\9')
$fqdn_tpdev = ($fqdn_vertical=="tp" and $fqdn_env=="dev")

case $fqdn_env {
  'dev': {
    $fqdn_env_full = 'development'
  }
  'stg': {
    $fqdn_env_full = 'staging'
  }
  'prd': {
    $fqdn_env_full = 'production'
  }
  default: {
    $fqdn_env_full = 'unknown'
  }
}

$guessed_silo = regsubst($fqdn,'^.*[.]([a-z0-9]{4})[.]gnmedia[.]net','\1')
case $guessed_silo {
    # We guessed it right
    lax1:   {$silo=$guessed_silo}
    lax2:   {$silo=$guessed_silo}
    stg1:   {$silo="lax1"}
    stg2:   {$silo="lax2"}
    dev1:   {$silo="lax3"}
    dev2:   {$silo="lax3"}
    # clean fall back for legacy (non puppetized servers)
    default: { $silo = "lax3" }
}

if ($at_silo == "") {
    $phys_silo = $silo
} else {
    $phys_silo = $at_silo
}

include ganglia

include common::mounthome

#if ($fqdn_tpdev) {
    #include audit
#}

$env  = regsubst($silo,'^([a-z]{3})[0-9]','\1')

filebucket { "main":
    server  => "puppet.gnmedia.net",
}

# generate password hash here with md5pass from the syslinux package:
#  /usr/bin/md5pass 'mypassword'
#  $1$F1AK0YNO$xaXLRsFfQX6bYQeqZm4iQ1
#
$rootpasswordhash = '$1$ysxY7rci$cJVC75oZy483FmGW3zDxZ1'

# Modifications to the default sudoers file
#
$sudoerscontent = "\n\
\n%sysadmins\tALL=(ALL)\tALL \
"

