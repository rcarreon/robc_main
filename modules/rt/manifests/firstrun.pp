# init setup for /app/shared for rt
class rt::firstrun {
  # initialize RT DB
  # don't need this, but leave it for ref
  exec {'rt-init':
    command => 'rt-setup-database --action init > /root/rt-init.log 2>&1 && touch /root/.rt.install',
    unless  => 'stat /root/.rt.install',
  }
  # fetch assettracker
  exec {'at-fetch':
    command => 'cd /root && wget -q http://yum.lax3.gnmedia.net/packages/assettracker.tar.gz && touch /root/.at.fetch',
    unless  => 'stat /root/.at.fetch',
    require => Exec['rt-init'],
  }
  # unzip assettracker
  exec {'at-unzip':
    command => 'cd /root && tar zxf assettracker.tar.gz && touch /root/.at.unzip',
    unless  => 'stat /root/.at.unzip',
    require => Exec['at-fetch'],
  }
  # install assettracker
  exec {'at-init':
    command => 'cd /root/at-1.2.3 && ./configure --with-rt-home=/usr/share/rt3 --with-rt-local=/usr/share/rt3 --with-rt-localhtml=/usr/share/rt3/html --with-db-admin=root > /root/at-init.log 2>&1 && make install >> /root/at-init.log 2>&1 && touch /root/.at.install',
    unless  => 'stat /root/.at.install',
    require => Exec['at-unzip'],
  }
  # fetch quickticket
  exec {'qt-fetch':
    command => 'cd /root && wget -q http://yum.lax3.gnmedia.net/packages/quickticket.tar.gz && touch /root/.qt.fetch',
    unless  => 'stat /root/.qt.fetch',
    require => Exec['at-init'],
  }
  # unzip quickticket
  exec {'qt-unzip':
    command => 'cd /root && tar zxf quickticket.tar.gz && touch /root/.qt.unzip',
    unless  => 'stat /root/.qt.unzip',
    require => Exec['qt-fetch'],
  }
  # install quickticket
  exec {'qt-init':
    command => "cd /root/QuickTicket && perl install.pl --destination=/usr/local/QuickTicket --rt_url=${rt_url} --qt_url=${qt_url} > /root/qt-init.log 2>&1 && touch /root/.qt.install",
    unless  => 'stat /root/.qt.install',
    require => Exec['qt-unzip'],
  }
}
