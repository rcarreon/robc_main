# Class: foreman::crons

class foreman::crons {
    cron { 'delete_reports':
        command     => 'cd /usr/share/foreman && rake reports:expire days=7 RAILS_ENV="production"',
        user        => root,
        hour        => 0,
        minute      => 0,
    }
}
