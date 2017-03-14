# Scala config file class
class scala::config {

  # profile.d settings for scala
  file { '/etc/profile.d/scala.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('techplatform/scala/scala.sh')

  }
}
