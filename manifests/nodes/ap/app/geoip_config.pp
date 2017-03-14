# GeoIP update config file
class ap::app::geoip::config($config_path) {
  # GeoIP Config stuff
  $license = decrypt('L0K3qxm/4u6FIVQ5sNvETA==')
  $user_id = '32923'
  $product_id = '106'

  file { "${config_path}/GeoIP.conf":
    ensure  => present,
    content => "LicenseKey ${license}\nUserId ${user_id}\nProductIds ${product_id}",
    owner   => 'adops-deploy',
    group   => 'apache',
    mode    => '0644',
  }
}
