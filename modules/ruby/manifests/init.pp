# this class installs ruby...one package at a time.
# so you can pick and choose, I suppose.

class ruby{
    package { 'ruby':
        ensure  => installed,
    }
}
