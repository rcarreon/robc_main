include cron
cron::monitor { 'important': warntime => 30, crittime => 60 }
