# kibana docroot definition
class kibana::docroot {
    file {"/app/shared/docroots":
        ensure  => directory,
        owner   => 'root',
        group   => 'root',
        mode    => '0755',
    }
}

