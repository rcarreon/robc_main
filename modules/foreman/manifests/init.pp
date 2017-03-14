# Class: foreman

class foreman {
    class { 'foreman::dependencies': } ->
    class { 'foreman::config': } ->
    package { 'foreman': ensure  => installed, } ->
    class { 'foreman::crons': }
}
