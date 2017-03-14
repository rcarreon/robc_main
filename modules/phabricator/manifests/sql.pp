class phabricator::sql {

    file { '/sql/fulltext':
        ensure => directory,
        owner  => 'mysql',
        group  => 'dba',
        mode   => '0775',
    }

    file { '/sql/fulltext/stopwords.txt':
        ensure  => file,
        owner   => 'mysql',
        group   => 'dba',
        mode    => '0644',
        source  => 'puppet:///modules/phabricator/stopwords.txt',
        require => File['/sql/fulltext'],
    }

}
