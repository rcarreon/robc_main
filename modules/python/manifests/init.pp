# Python class
# keeping origin of python module for posterity ... https://gist.github.com/309708
class python {
    include git::client
        package { 'python':
            ensure => installed,
        }
}
