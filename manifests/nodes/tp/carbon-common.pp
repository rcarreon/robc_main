class carbon-common {
        class {"python::install":
             prefix => "/usr/local",
             tmpdir => "/tmp",
             pipversion => "1.0.2",
             version => "2.6.5",
        }

        file { "/usr/bin/python":
           ensure => "/usr/local/bin/python2.6",
           require => Class["python::install"]
        }
        exec { "yum-python-2.4ify":
           command => "sed -i '1s/python.*/python2.4/' /usr/bin/yum",
           unless => "grep -q python2.4 /usr/bin/yum"
        }

        package { ["bzr","sqlite.x86_64","sqlite-devel.x86_64"]:
                ensure => installed,
        }

        #FIXME: After upgrading to python 2.6.5, yumhelper stopped working
        #Need to run /usr/bin/python2.4 /usr/lib/ruby/site_ruby/1.8/puppet/provider/package/yumhelper.py
        #Need to run yum install pixman-devel pixman cairo-devel cairo manually

        package { ["pixman-devel", "pixman", "cairo-devel", "cairo"]:
                ensure => installed,
        }

        python::install::pip{bzr:
        #version => "2.4.0",
        ensure	=> present
        }
        
        python::install::pip{pysqlite:
        #version => "2.6.3",
        ensure	=> present
        }
        
        python::install::pip{simplejson:
        #version => "2.1.6",
        ensure	=> present
        }

        python::install::pip{"Twisted":
        #version => "11.0",
        ensure	=> present
        }

        #pip's version is too old, it's not stable
        #please use bzr branch -r 346 lp:graphite
        #460 and 420 are not stable!!!!

        #python::install::pip{"whisper":
        #version => "1.0.2",
        #ensure	=> present
        #}

        #python::install::pip{"carbon":
        #version => "1.0.2",
        #ensure	=> present
        #}

        python::install::pip{"Django":
        #version => "1.3",
        ensure	=> present
        }

        #python::install::pip{"http://cairographics.org/releases/py2cairo-1.8.10.tar.gz":
        #version => "1.0.2",
        #ensure	=> present
        #}

	file { "/app/data":
		ensure	=> link,
		target	=> "/app/shared",
	}

	common::nfsmount { "/app/shared":
		device  => "nfsB-netapp1.gnmedia.net:/vol/nac1b_tp_lax_prd_app_shared/carbon",
	}

}

