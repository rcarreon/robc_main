class adops::pyenv {
  # pyenv's dependencies
  package { ["gcc", "zlib-devel", "bzip2-devel", "readline-devel", "sqlite-devel", "openssl-devel"]:
    ensure => "present",
  }
}
